import SwiftUI

struct TodoDetailView: View {
    @ObservedObject var viewModel: TodoViewModel
    let todo: TodoData
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = false
    @State private var title = ""
    @State private var details = ""
    @State private var location = ""
    @State private var targetDate: Date?
    @State private var targetTime: Date?
    @State private var isCompleted = false
    
    var body: some View {
        Group {
            if isEditing {
                TodoEditView(
                    viewModel: viewModel,
                    todo: todo,
                    isEditing: $isEditing,
                    title: $title,
                    details: $details,
                    location: $location,
                    targetDate: $targetDate,
                    targetTime: $targetTime,
                    isCompleted: $isCompleted
                )
            } else {
                TodoViewView(
                    viewModel: viewModel,
                    todo: todo,
                    dismiss: dismiss,
                    isEditing: $isEditing
                )
            }
        }
        .onAppear {
            title = todo.title
            details = todo.details ?? ""
            location = todo.location ?? ""
            targetDate = todo.targetDate
            targetTime = todo.targetTime
            isCompleted = todo.isCompleted
        }
    }
}

struct TodoViewView: View {
    @ObservedObject var viewModel: TodoViewModel
    let todo: TodoData
    let dismiss: DismissAction
    @Binding var isEditing: Bool
    
    // Track if the todo was deleted from the view model
    var todoExists: Bool {
        viewModel.todos.contains { $0.id == todo.id }
    }
    
    var body: some View {
        if !todoExists {
            DispatchQueue.main.async {
                dismiss()
            }
            return AnyView(EmptyView())
        }
        
        return AnyView(VStack(alignment: .leading, spacing: 20) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Button(action: { viewModel.toggleCompletion(id: todo.id) }) {
                            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.title)
                                .foregroundStyle(todo.isCompleted ? .green : .gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(todo.title)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .strikethrough(todo.isCompleted)
                            
                            Text("Created \(todo.createdAt.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    if let details = todo.details, !details.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Details")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            
                            Text(details)
                                .font(.body)
                        }
                    }
                    
                    if let targetDate = todo.targetDate {
                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .foregroundStyle(.blue)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Target Date")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(targetDate.formatted(date: .complete, time: .omitted))
                                    .font(.body)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    if let targetTime = todo.targetTime {
                        HStack(spacing: 12) {
                            Image(systemName: "clock.fill")
                                .foregroundStyle(.orange)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Target Time")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(targetTime.formatted(date: .omitted, time: .shortened))
                                    .font(.body)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    if let location = todo.location, !location.isEmpty {
                        HStack(spacing: 12) {
                            Image(systemName: "location.fill")
                                .foregroundStyle(.red)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Location")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(location)
                                    .font(.body)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(16)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(role: .destructive) {
                    viewModel.deleteTodo(id: todo.id)
                    // Let the todoExists check in the view body handle dismissal
                } label: {
                    Label("Delete", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button {
                    isEditing = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(16)
        }
        .navigationTitle("Todo Details")
        .navigationBarTitleDisplayMode(.inline))
    }
}

struct TodoEditView: View {
    @ObservedObject var viewModel: TodoViewModel
    let todo: TodoData
    @Binding var isEditing: Bool
    @Binding var title: String
    @Binding var details: String
    @Binding var location: String
    @Binding var targetDate: Date?
    @Binding var targetTime: Date?
    @Binding var isCompleted: Bool
    
    @State private var includeDate = false
    @State private var includeTime = false
    @State private var includeLocation = false
    
    var body: some View {
        Form {
            Section(header: Text("Required")) {
                TextField("Title", text: $title)
            }
            
            Section(header: Text("Optional Details")) {
                TextField("Details", text: $details, axis: .vertical)
                    .lineLimit(3...5)
                
                Toggle("Add target date", isOn: $includeDate)
                if includeDate {
                    DatePicker("Date", selection: Binding(
                        get: { targetDate ?? Date() },
                        set: { targetDate = $0 }
                    ), displayedComponents: .date)
                }
                
                if includeDate {
                    Toggle("Add time", isOn: $includeTime)
                    if includeTime {
                        DatePicker("Time", selection: Binding(
                            get: { targetTime ?? Date() },
                            set: { targetTime = $0 }
                        ), displayedComponents: .hourAndMinute)
                    }
                }
                
                Toggle("Add location", isOn: $includeLocation)
                if includeLocation {
                    TextField("Location", text: $location)
                }
            }
        }
        .navigationTitle("Edit Todo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isEditing = false
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    viewModel.updateTodo(
                        id: todo.id,
                        title: title.trimmingCharacters(in: .whitespaces),
                        details: details.isEmpty ? nil : details,
                        location: location.isEmpty ? nil : location,
                        targetDate: includeDate ? targetDate : nil,
                        targetTime: includeTime ? targetTime : nil,
                        isCompleted: isCompleted
                    )
                    isEditing = false
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .onAppear {
            includeDate = targetDate != nil
            includeTime = targetTime != nil
            includeLocation = !location.isEmpty
        }
    }
}

#Preview {
    let todo = TodoData(
        title: "Sample Todo",
        details: "This is a sample todo",
        location: "Home",
        targetDate: Date()
    )
    
    return NavigationStack {
        TodoDetailView(viewModel: TodoViewModel(), todo: todo)
    }
}
