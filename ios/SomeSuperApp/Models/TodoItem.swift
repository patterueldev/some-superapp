import Foundation
import CoreData

@objc(TodoItem)
final class TodoItem: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var details: String?
    @NSManaged var location: String?
    @NSManaged var targetDate: Date?
    @NSManaged var targetTime: Date?
    @NSManaged var isCompleted: Bool
    @NSManaged var createdAt: Date
    @NSManaged var updatedAt: Date
    
    convenience init(context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "TodoItem", in: context)!, insertInto: context)
        self.id = UUID()
        self.isCompleted = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
