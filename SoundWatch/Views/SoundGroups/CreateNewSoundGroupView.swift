//
//  AddSoundGroupView.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 2/26/25.
//

import SwiftUI
// The View wherein you add a new sound to the SoundGroup
import SwiftData

struct CreateNewSoundGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var newGroupName = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Group Name", text: $newGroupName)
            }
            .navigationTitle("Add Sound Group")
            .toolbar {
                Button("Done") {
                    if !newGroupName.isEmpty {
                        let newGroup = SoundGroup(name: newGroupName, isEnabled: false)
                        modelContext.insert(newGroup) // Saves to SwiftData
                        try? modelContext.save()
                        dismiss()
                    }
                }
            }
        }
    }
}


struct AddSoundGroupView_Previews: PreviewProvider {
    static var previews: some View {
        let modelContainer = try! ModelContainer(for: SoundGroup.self) // SwiftData container

        return CreateNewSoundGroupView()
            .modelContainer(modelContainer) // Attach SwiftData context
            .previewDisplayName("Create New Sound Group")
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    let content: (Binding<Value>) -> Content  // ✅ Use generic Content instead of 'any View'

    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {  // ✅ Use generic Content
        self._value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}


