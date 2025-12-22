import Foundation
import CoreData

class DataController: NSObject, ObservableObject, @unchecked Sendable {
    let container: NSPersistentCloudKitContainer

    @Published var savedError: String?

    nonisolated static let shared = DataController()

    override init() {
        // Create a programmatic data model
        let model = NSManagedObjectModel()
        
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
        
        model.entities = [todoEntity]
        
        self.container = NSPersistentCloudKitContainer(name: "SomeSuperApp", managedObjectModel: model)
        super.init()

        if let description = container.persistentStoreDescriptions.first {
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                containerIdentifier: "iCloud.com.patterueldev.somesuperapp"
            )
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }

        // Load stores synchronously to ensure they're available immediately
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Failed to load Core Data: \(error.localizedDescription)")
            } else {
                print("Successfully loaded Core Data store")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
                savedError = nil
                print("Successfully saved to Core Data")
            } catch {
                let errorMsg = error.localizedDescription
                print("Failed to save to Core Data: \(errorMsg)")
                savedError = errorMsg
            }
        }
    }

    func delete(_ object: NSManagedObject) {
        let context = container.viewContext
        context.delete(object)
        save()
    }
}
