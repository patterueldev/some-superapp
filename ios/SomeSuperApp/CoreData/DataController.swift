import Foundation
import CoreData

class DataController: NSObject, ObservableObject, @unchecked Sendable {
    // Concurrency-safe static flag: immutable constant to avoid global mutable state
    static let isCloudKitEnabled: Bool = false

    // Use a general NSPersistentContainer so we can fall back from CloudKit if needed
    var container: NSPersistentContainer

    @Published var savedError: String?

    nonisolated static let shared = DataController()

    override init() {
        // Create a programmatic data model
        let model = NSManagedObjectModel()
        
        let todoEntity = NSEntityDescription()
        todoEntity.name = "TodoItem"
        // Bind the entity to the actual Swift class correctly
        todoEntity.managedObjectClassName = NSStringFromClass(TodoItem.self)
        
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
        
        if Self.isCloudKitEnabled {
            // Try CloudKit first
            let cloudKitContainer = NSPersistentCloudKitContainer(name: "SomeSuperApp", managedObjectModel: model)
            var didLoadCloudKit = false
            
            if let description = cloudKitContainer.persistentStoreDescriptions.first {
                description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                    containerIdentifier: "iCloud.com.patterueldev.somesuperapp"
                )
                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
                description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            }
            
            let group = DispatchGroup()
            group.enter()
            cloudKitContainer.loadPersistentStores { _, error in
                if let error = error {
                    print("Failed to load Core Data (CloudKit): \(error.localizedDescription)")
                } else {
                    print("Successfully loaded Core Data store (CloudKit)")
                    didLoadCloudKit = true
                }
                group.leave()
            }
            group.wait()
            
            if didLoadCloudKit {
                container = cloudKitContainer
            } else {
                // Fallback to local if CloudKit failed
                let localContainer = NSPersistentContainer(name: "SomeSuperApp", managedObjectModel: model)
                let localGroup = DispatchGroup()
                localGroup.enter()
                localContainer.loadPersistentStores { _, error in
                    if let error = error {
                        print("Failed to load Core Data (Local): \(error.localizedDescription)")
                    } else {
                        print("Successfully loaded Core Data store (Local)")
                    }
                    localGroup.leave()
                }
                localGroup.wait()
                container = localContainer
            }
        } else {
            // CloudKit disabled: use local store only
            let localContainer = NSPersistentContainer(name: "SomeSuperApp", managedObjectModel: model)
            let group = DispatchGroup()
            group.enter()
            localContainer.loadPersistentStores { _, error in
                if let error = error {
                    print("Failed to load Core Data (Local): \(error.localizedDescription)")
                } else {
                    print("Successfully loaded Core Data store (Local)")
                }
                group.leave()
            }
            group.wait()
            container = localContainer
        }
        
        super.init()
        
        // Common context configuration
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
