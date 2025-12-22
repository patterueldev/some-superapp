import XCTest
import CoreData
@testable import Some_SuperApp

class TodoViewModelTests: XCTestCase {
    var sut: TodoViewModel!
    var mockDataController: DataController!
    var testContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        // Create in-memory Core Data stack for testing
        let testModel = NSManagedObjectModel()
        
        let todoEntity = NSEntityDescription()
        todoEntity.name = "TodoItem"
        todoEntity.managedObjectClassName = "TodoItem"
        
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .UUIDAttributeType
        idAttribute.isOptional = false
        
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = false
        
        let detailsAttribute = NSAttributeDescription()
        detailsAttribute.name = "details"
        detailsAttribute.attributeType = .stringAttributeType
        detailsAttribute.isOptional = true
        
        let locationAttribute = NSAttributeDescription()
        locationAttribute.name = "location"
        locationAttribute.attributeType = .stringAttributeType
        locationAttribute.isOptional = true
        
        let targetDateAttribute = NSAttributeDescription()
        targetDateAttribute.name = "targetDate"
        targetDateAttribute.attributeType = .dateAttributeType
        targetDateAttribute.isOptional = true
        
        let targetTimeAttribute = NSAttributeDescription()
        targetTimeAttribute.name = "targetTime"
        targetTimeAttribute.attributeType = .dateAttributeType
        targetTimeAttribute.isOptional = true
        
        let isCompletedAttribute = NSAttributeDescription()
        isCompletedAttribute.name = "isCompleted"
        isCompletedAttribute.attributeType = .booleanAttributeType
        isCompletedAttribute.isOptional = false
        isCompletedAttribute.defaultValue = false
        
        let createdAtAttribute = NSAttributeDescription()
        createdAtAttribute.name = "createdAt"
        createdAtAttribute.attributeType = .dateAttributeType
        createdAtAttribute.isOptional = false
        
        let updatedAtAttribute = NSAttributeDescription()
        updatedAtAttribute.name = "updatedAt"
        updatedAtAttribute.attributeType = .dateAttributeType
        updatedAtAttribute.isOptional = false
        
        todoEntity.properties = [
            idAttribute, titleAttribute, detailsAttribute, locationAttribute,
            targetDateAttribute, targetTimeAttribute, isCompletedAttribute,
            createdAtAttribute, updatedAtAttribute
        ]
        
        testModel.entities = [todoEntity]
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: testModel)
        try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        testContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        testContext.persistentStoreCoordinator = coordinator
        
        // Create a test DataController with the in-memory store
        mockDataController = createTestDataController(with: coordinator, model: testModel)
        sut = TodoViewModel(dataController: mockDataController)
    }
    
    override func tearDown() {
        sut = nil
        mockDataController = nil
        testContext = nil
        super.tearDown()
    }
    
    private func createTestDataController(with coordinator: NSPersistentStoreCoordinator, model: NSManagedObjectModel) -> DataController {
        let controller = DataController()
        controller.container = NSPersistentCloudKitContainer(name: "TestSomeSuperApp", managedObjectModel: model)
        if let description = controller.container.persistentStoreDescriptions.first {
            description.url = nil
            controller.container.persistentStoreDescriptions = [description]
        }
        return controller
    }
    
    func testAddTodo() {
        // Given
        let title = "New Todo"
        let details = "Test details"
        let location = "Home"
        let targetDate = Date()
        let targetTime = Date()
        
        let initialCount = sut.todos.count
        
        // When
        sut.addTodo(title: title, details: details, location: location, targetDate: targetDate, targetTime: targetTime)
        
        // Then
        XCTAssertEqual(sut.todos.count, initialCount + 1)
        let addedTodo = sut.todos.last
        XCTAssertEqual(addedTodo?.title, title)
        XCTAssertEqual(addedTodo?.details, details)
        XCTAssertEqual(addedTodo?.location, location)
        XCTAssertFalse(addedTodo?.isCompleted ?? true)
    }
    
    func testAddTodoMinimal() {
        // Given - Only title, no optional fields
        let title = "Minimal Todo"
        let initialCount = sut.todos.count
        
        // When
        sut.addTodo(title: title)
        
        // Then
        XCTAssertEqual(sut.todos.count, initialCount + 1)
        let addedTodo = sut.todos.last
        XCTAssertEqual(addedTodo?.title, title)
        XCTAssertNil(addedTodo?.details)
        XCTAssertNil(addedTodo?.location)
        XCTAssertNil(addedTodo?.targetDate)
    }
    
    func testToggleCompletion() {
        // Given
        let todo = TodoItem(context: testContext)
        todo.id = UUID()
        todo.title = "Test Todo"
        todo.isCompleted = false
        todo.createdAt = Date()
        todo.updatedAt = Date()
        try! testContext.save()
        
        sut.fetchTodos()
        let initialState = sut.todos.first?.isCompleted ?? false
        
        // When
        sut.toggleCompletion(sut.todos.first!)
        
        // Then
        XCTAssertNotEqual(sut.todos.first?.isCompleted, initialState)
        XCTAssertTrue(sut.todos.first?.isCompleted ?? false)
    }
    
    func testUpdateTodo() {
        // Given
        let todo = TodoItem(context: testContext)
        todo.id = UUID()
        todo.title = "Original Title"
        todo.details = nil
        todo.isCompleted = false
        todo.createdAt = Date()
        todo.updatedAt = Date()
        try! testContext.save()
        
        sut.fetchTodos()
        let todoToUpdate = sut.todos.first!
        
        // When
        let newTitle = "Updated Title"
        let newDetails = "Updated Details"
        sut.updateTodo(todoToUpdate, title: newTitle, details: newDetails, location: nil, targetDate: nil, targetTime: nil, isCompleted: false)
        
        // Then
        XCTAssertEqual(todoToUpdate.title, newTitle)
        XCTAssertEqual(todoToUpdate.details, newDetails)
    }
    
    func testDeleteTodo() {
        // Given
        let todo = TodoItem(context: testContext)
        todo.id = UUID()
        todo.title = "To Delete"
        todo.isCompleted = false
        todo.createdAt = Date()
        todo.updatedAt = Date()
        try! testContext.save()
        
        sut.fetchTodos()
        let initialCount = sut.todos.count
        let todoToDelete = sut.todos.first!
        
        // When
        sut.deleteTodo(todoToDelete)
        
        // Then
        XCTAssertEqual(sut.todos.count, initialCount - 1)
    }
    
    func testFetchTodos() {
        // Given - Create some todos directly in Core Data
        for i in 0..<5 {
            let todo = TodoItem(context: testContext)
            todo.id = UUID()
            todo.title = "Todo \(i)"
            todo.isCompleted = false
            todo.createdAt = Date()
            todo.updatedAt = Date()
        }
        try! testContext.save()
        
        // When
        sut.fetchTodos()
        
        // Then
        XCTAssertEqual(sut.todos.count, 5)
    }
    
    func testTodoSortingByCompletion() {
        // Given
        let todo1 = TodoItem(context: testContext)
        todo1.id = UUID()
        todo1.title = "Completed Todo"
        todo1.isCompleted = true
        todo1.createdAt = Date()
        todo1.updatedAt = Date()
        
        let todo2 = TodoItem(context: testContext)
        todo2.id = UUID()
        todo2.title = "Incomplete Todo"
        todo2.isCompleted = false
        todo2.createdAt = Date()
        todo2.updatedAt = Date()
        
        try! testContext.save()
        
        // When
        sut.fetchTodos()
        
        // Then - Incomplete todos should come before completed ones
        XCTAssertFalse(sut.todos.first?.isCompleted ?? true)
        XCTAssertTrue(sut.todos.last?.isCompleted ?? false)
    }
}
