import XCTest
import CoreData
@testable import Some_SuperApp

class TodoIntegrationTests: XCTestCase {
    var viewModel: TodoViewModel!
    var dataController: DataController!
    var testContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        // Create in-memory Core Data stack for testing
        let testModel = createTestModel()
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: testModel)
        try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        testContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        testContext.persistentStoreCoordinator = coordinator
        
        dataController = createTestDataController(with: coordinator, model: testModel)
        viewModel = TodoViewModel(dataController: dataController)
    }
    
    override func tearDown() {
        viewModel = nil
        dataController = nil
        testContext = nil
        super.tearDown()
    }
    
    private func createTestModel() -> NSManagedObjectModel {
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
        return testModel
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
    
    // MARK: - App Lifecycle Integration Tests
    
    func testFullTodoLifecycle() {
        // Scenario: User creates, edits, completes, and deletes a todo
        
        // Step 1: Create a todo
        let title = "Grocery Shopping"
        let details = "Buy milk, bread, and eggs"
        let location = "Safeway"
        let targetDate = Date().addingTimeInterval(86400) // Tomorrow
        
        viewModel.addTodo(title: title, details: details, location: location, targetDate: targetDate)
        
        XCTAssertEqual(viewModel.todos.count, 1)
        let todo = viewModel.todos.first!
        XCTAssertEqual(todo.title, title)
        XCTAssertFalse(todo.isCompleted)
        
        // Step 2: Mark as incomplete initially, then complete
        XCTAssertFalse(todo.isCompleted)
        viewModel.toggleCompletion(todo)
        XCTAssertTrue(todo.isCompleted)
        
        // Step 3: Update the todo
        viewModel.updateTodo(
            todo,
            title: "Grocery Shopping - Done",
            details: "All items purchased",
            location: location,
            targetDate: targetDate,
            targetTime: nil,
            isCompleted: true
        )
        
        XCTAssertEqual(todo.title, "Grocery Shopping - Done")
        
        // Step 4: Delete the todo
        viewModel.deleteTodo(todo)
        XCTAssertEqual(viewModel.todos.count, 0)
    }
    
    func testMultipleTodosWithDifferentStates() {
        // Scenario: User has multiple todos in various states
        
        // Create 3 todos
        viewModel.addTodo(title: "Task 1")
        viewModel.addTodo(title: "Task 2")
        viewModel.addTodo(title: "Task 3")
        
        XCTAssertEqual(viewModel.todos.count, 3)
        
        // Complete Task 2
        let task2 = viewModel.todos[1]
        viewModel.toggleCompletion(task2)
        XCTAssertTrue(task2.isCompleted)
        
        // Verify incomplete tasks come first in sort order
        let incompleteCount = viewModel.todos.filter { !$0.isCompleted }.count
        let completeCount = viewModel.todos.filter { $0.isCompleted }.count
        
        XCTAssertEqual(incompleteCount, 2)
        XCTAssertEqual(completeCount, 1)
        
        // All incomplete todos should be before completed ones
        var foundIncomplete = false
        var foundComplete = false
        for todo in viewModel.todos {
            if todo.isCompleted {
                foundComplete = true
            } else if foundComplete {
                XCTFail("Incomplete todo found after completed todo")
            } else {
                foundIncomplete = true
            }
        }
    }
    
    func testAddTodoWithAllFields() {
        // Scenario: User creates a todo with all optional fields filled
        
        let title = "Project Deadline"
        let details = "Complete the iOS app development"
        let location = "Office"
        let targetDate = Date().addingTimeInterval(604800) // Next week
        let targetTime = Date().addingTimeInterval(36000) // 10 hours from now
        
        viewModel.addTodo(
            title: title,
            details: details,
            location: location,
            targetDate: targetDate,
            targetTime: targetTime
        )
        
        let todo = viewModel.todos.first!
        XCTAssertEqual(todo.title, title)
        XCTAssertEqual(todo.details, details)
        XCTAssertEqual(todo.location, location)
        XCTAssertNotNil(todo.targetDate)
        XCTAssertNotNil(todo.targetTime)
        XCTAssertFalse(todo.isCompleted)
    }
    
    func testAddEmptyDetailsNotStored() {
        // Scenario: User creates a todo but leaves details empty
        
        viewModel.addTodo(title: "Simple Task", details: "")
        
        let todo = viewModel.todos.first!
        XCTAssertNil(todo.details)
    }
    
    func testEditTodoPreservesCreatedAt() {
        // Scenario: User edits a todo, should preserve original creation time
        
        viewModel.addTodo(title: "Original Title")
        let todo = viewModel.todos.first!
        let originalCreatedAt = todo.createdAt
        
        // Wait a small amount of time and update
        Thread.sleep(forTimeInterval: 0.1)
        
        viewModel.updateTodo(
            todo,
            title: "Updated Title",
            details: nil,
            location: nil,
            targetDate: nil,
            targetTime: nil,
            isCompleted: false
        )
        
        XCTAssertEqual(todo.createdAt, originalCreatedAt)
        XCTAssertNotEqual(todo.updatedAt, originalCreatedAt)
    }
    
    func testPersistenceAcrossFetch() {
        // Scenario: Create a todo, fetch todos, verify persistence
        
        viewModel.addTodo(title: "Persistent Task", details: "Should survive fetch")
        let firstFetchCount = viewModel.todos.count
        
        // Fetch again
        viewModel.fetchTodos()
        let secondFetchCount = viewModel.todos.count
        
        XCTAssertEqual(firstFetchCount, secondFetchCount)
        XCTAssertEqual(viewModel.todos.first?.title, "Persistent Task")
    }
}
