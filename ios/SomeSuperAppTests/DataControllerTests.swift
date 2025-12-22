import XCTest
import CoreData
@testable import Some_SuperApp

class DataControllerTests: XCTestCase {
    var sut: DataController!
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
    }
    
    override func tearDown() {
        sut = nil
        testContext = nil
        super.tearDown()
    }
    
    func testDataControllerInitialization() {
        // Given & When
        let controller = DataController()
        
        // Then
        XCTAssertNotNil(controller.container)
        XCTAssertNotNil(controller.container.viewContext)
    }
    
    func testSaveWithChanges() {
        // Given
        let todo = TodoItem(context: testContext)
        todo.id = UUID()
        todo.title = "Test Todo"
        todo.isCompleted = false
        todo.createdAt = Date()
        todo.updatedAt = Date()
        
        try! testContext.save()
        
        // When
        todo.title = "Updated Title"
        try! testContext.save()
        
        // Then - Verify the change persisted
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        let results = try! testContext.fetch(fetchRequest)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Updated Title")
    }
    
    func testDeleteTodoItem() {
        // Given
        let todo = TodoItem(context: testContext)
        todo.id = UUID()
        todo.title = "Test Todo"
        todo.isCompleted = false
        todo.createdAt = Date()
        todo.updatedAt = Date()
        try! testContext.save()
        
        // When
        testContext.delete(todo)
        try! testContext.save()
        
        // Then - Verify deletion
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        let results = try! testContext.fetch(fetchRequest)
        XCTAssertEqual(results.count, 0)
    }
    
    func testFetchTodos() {
        // Given
        for i in 0..<3 {
            let todo = TodoItem(context: testContext)
            todo.id = UUID()
            todo.title = "Todo \(i)"
            todo.isCompleted = false
            todo.createdAt = Date()
            todo.updatedAt = Date()
        }
        try! testContext.save()
        
        // When
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        let results = try! testContext.fetch(fetchRequest)
        
        // Then
        XCTAssertEqual(results.count, 3)
    }
}
