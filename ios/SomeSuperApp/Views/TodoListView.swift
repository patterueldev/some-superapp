import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var showAddTodo = false
    
    var completedCount: Int {
        viewModel.todos.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        ZStack {
            if viewModel.todos.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    
                    Text("No todos yet")
                        .font(.headline)
                    
                    Text("Create your first todo to get started")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.todos, id: \.self) { todo in
                        NavigationLink(destination: TodoDetailView(viewModel: viewModel, todo: todo)) {
                            TodoRowView(todo: todo, onToggle: {
                                viewModel.toggleCompletion(todo)
                            })
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteTodo(todo)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("What To Do")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showAddTodo = true }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
            
            if !viewModel.todos.isEmpty {
                ToolbarItem(placement: .status) {
                    Text("\(completedCount)/\(viewModel.todos.count) done")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .sheet(isPresented: $showAddTodo) {
            AddTodoView(viewModel: viewModel, isPresented: $showAddTodo)
        }
    }
}

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(todo.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.body)
                    .strikethrough(todo.isCompleted, color: .gray)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                
                if let targetDate = todo.targetDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(targetDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption2)
                    }
                    .foregroundStyle(.secondary)
                }
                
                if let location = todo.location, !location.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption2)
                        Text(location)
                            .font(.caption2)
                    }
                    .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        TodoListView()
    }
}
