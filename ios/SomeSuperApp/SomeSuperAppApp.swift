import SwiftUI

@main
struct SomeSuperAppApp: App {
    @StateObject private var dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
