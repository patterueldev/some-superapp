import Foundation
import CoreData

class TodoViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    private let dataController: DataController
    private let fetchedResultsController: NSFetchedResultsController<TodoItem>
    
    @Published var todos: [TodoItem] = []
    @Published var isLoading = false
    
    init(dataController: DataController = .shared) {
        self.dataController = dataController
        
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TodoItem.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TodoItem.targetDate, ascending: true),
            NSSortDescriptor(keyPath: \TodoItem.createdAt, ascending: false)
        ]
        
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        self.fetchedResultsController.delegate = self
        fetchTodos()
    }
    
    func fetchTodos() {
        let context = dataController.container.viewContext
        let request = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TodoItem.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TodoItem.targetDate, ascending: true),
            NSSortDescriptor(keyPath: \TodoItem.createdAt, ascending: false)
        ]
        
        do {
            self.todos = try context.fetch(request)
        } catch {
            print("Failed to fetch todos: \(error.localizedDescription)")
        }
    }
    
    func addTodo(
        title: String,
        details: String? = nil,
        location: String? = nil,
        targetDate: Date? = nil,
        targetTime: Date? = nil
    ) {
        let context = dataController.container.viewContext
        let newTodo = TodoItem(context: context)
        newTodo.title = title
        newTodo.details = details?.isEmpty == false ? details : nil
        newTodo.location = location?.isEmpty == false ? location : nil
        newTodo.targetDate = targetDate
        newTodo.targetTime = targetTime
        
        dataController.save()
        fetchTodos()
    }
    
    func updateTodo(
        _ todo: TodoItem,
        title: String,
        details: String? = nil,
        location: String? = nil,
        targetDate: Date? = nil,
        targetTime: Date? = nil,
        isCompleted: Bool
    ) {
        todo.title = title
        todo.details = details?.isEmpty == false ? details : nil
        todo.location = location?.isEmpty == false ? location : nil
        todo.targetDate = targetDate
        todo.targetTime = targetTime
        todo.isCompleted = isCompleted
        todo.updatedAt = Date()
        
        dataController.save()
        fetchTodos()
    }
    
    func deleteTodo(_ todo: TodoItem) {
        dataController.delete(todo)
        fetchTodos()
    }
    
    func toggleCompletion(_ todo: TodoItem) {
        todo.isCompleted.toggle()
        todo.updatedAt = Date()
        
        dataController.save()
        fetchTodos()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchTodos()
    }
}
