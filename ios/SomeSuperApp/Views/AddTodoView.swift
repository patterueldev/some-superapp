import SwiftUI

struct AddTodoView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Binding var isPresented: Bool
    
    @State private var title = ""
    @State private var details = ""
    @State private var location = ""
    @State private var targetDate: Date?
    @State private var targetTime: Date?
    @State private var includeDate = false
    @State private var includeTime = false
    @State private var includeLocation = false
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Required")) {
                    TextField("Title *", text: $title)
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
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addTodo(
                            title: title.trimmingCharacters(in: .whitespaces),
                            details: details.isEmpty ? nil : details,
                            location: location.isEmpty ? nil : location,
                            targetDate: includeDate ? targetDate : nil,
                            targetTime: includeTime ? targetTime : nil
                        )
                        isPresented = false
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

#Preview {
    AddTodoView(viewModel: TodoViewModel(), isPresented: .constant(true))
}
