import Foundation
import CoreData

class DataController: NSObject, ObservableObject, @unchecked Sendable {
    let container: NSPersistentCloudKitContainer

    @Published var savedError: String?

    nonisolated static let shared = DataController()

    override init() {
        self.container = NSPersistentCloudKitContainer(name: "SomeSuperApp")
        super.init()

        if let description = container.persistentStoreDescriptions.first {
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                containerIdentifier: "iCloud.com.patterueldev.somesuperapp"
            )
            description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load Core Data: \(error.localizedDescription)")
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
            } catch {
                savedError = error.localizedDescription
            }
        }
    }

    func delete(_ object: NSManagedObject) {
        let context = container.viewContext
        context.delete(object)
        save()
    }
}
