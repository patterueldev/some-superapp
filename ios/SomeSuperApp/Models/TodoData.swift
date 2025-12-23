import Foundation

/// Value type representation of a Todo item
/// Used by Views to avoid direct NSManagedObject dependencies
struct TodoData: Identifiable, Equatable {
    let id: UUID
    let title: String
    let details: String?
    let location: String?
    let targetDate: Date?
    let targetTime: Date?
    let isCompleted: Bool
    let createdAt: Date
    let updatedAt: Date
    
    /// Create from a TodoItem NSManagedObject
    init(from managedObject: TodoItem) {
        self.id = managedObject.id
        self.title = managedObject.title
        self.details = managedObject.details
        self.location = managedObject.location
        self.targetDate = managedObject.targetDate
        self.targetTime = managedObject.targetTime
        self.isCompleted = managedObject.isCompleted
        self.createdAt = managedObject.createdAt
        self.updatedAt = managedObject.updatedAt
    }
    
    /// Direct initialization for testing or temporary creation
    init(
        id: UUID = UUID(),
        title: String,
        details: String? = nil,
        location: String? = nil,
        targetDate: Date? = nil,
        targetTime: Date? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.location = location
        self.targetDate = targetDate
        self.targetTime = targetTime
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
