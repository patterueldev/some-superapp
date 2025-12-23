import Foundation
import CoreData

class TodoViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    private let dataController: DataController
    private let fetchedResultsController: NSFetchedResultsController<TodoItem>
    
    @Published var todos: [TodoData] = []
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
            let managedObjects = try context.fetch(request)
            self.todos = managedObjects.map { TodoData(from: $0) }
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
        id: UUID,
        title: String,
        details: String? = nil,
        location: String? = nil,
        targetDate: Date? = nil,
        targetTime: Date? = nil,
        isCompleted: Bool
    ) {
        let context = dataController.container.viewContext
        let request = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let todo = try context.fetch(request).first {
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
        } catch {
            print("Failed to update todo: \(error.localizedDescription)")
        }
    }
    
    func deleteTodo(id: UUID) {
        let context = dataController.container.viewContext
        let request = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let todo = try context.fetch(request).first {
                dataController.delete(todo)
                fetchTodos()
            }
        } catch {
            print("Failed to delete todo: \(error.localizedDescription)")
        }
    }
    
    func toggleCompletion(id: UUID) {
        let context = dataController.container.viewContext
        let request = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let todo = try context.fetch(request).first {
                todo.isCompleted.toggle()
                todo.updatedAt = Date()
                
                dataController.save()
                fetchTodos()
            }
        } catch {
            print("Failed to toggle completion: \(error.localizedDescription)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchTodos()
    }
}
