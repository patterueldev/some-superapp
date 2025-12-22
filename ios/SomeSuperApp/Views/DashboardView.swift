import SwiftUI

struct DashboardView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Select a feature to get started")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                
                // Feature Grid
                ScrollView {
                    VStack(spacing: 16) {
                        // Todo Feature Card
                        NavigationLink(destination: TodoListView()) {
                            FeatureCard(
                                title: "What To Do",
                                subtitle: "Manage your tasks",
                                icon: "checkmark.circle.fill",
                                color: .blue
                            )
                        }
                        
                        // Placeholder for future features
                        FeatureCard(
                            title: "Coming Soon",
                            subtitle: "More features arriving soon",
                            icon: "sparkles",
                            color: .gray,
                            isDisabled: true
                        )
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FeatureCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    var isDisabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(color)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

#Preview {
    DashboardView()
}
