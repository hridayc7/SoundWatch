//
//  SoundGroups.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 2/11/25.
//

import SwiftUI

// View containing the list of all the SoundGroups the User has created and default sound groups
import SwiftData

struct SoundGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var soundGroups: [SoundGroup] // Fetches persisted sound groups
    
    @State private var showingAddGroup = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(soundGroups) { group in
                    NavigationLink(destination: SoundGroupDetailedView(soundGroup: group)) {
                        HStack {
                            Text(group.name)
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { group.isEnabled },
                                set: { newValue in
                                    group.isEnabled = newValue
                                    try? modelContext.save()
                                    print("Updated \(group.name): \(group.isEnabled)")
                                }
                            ))
                        }
                    }
                }
                .onDelete(perform: deleteGroup) // Swipe-to-delete
            }
            .navigationTitle("SoundGroups")
            .toolbar {
                Button(action: { showingAddGroup = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddGroup) {
                CreateNewSoundGroupView()
            }
        }
        .onAppear{
            //Print sound group here along with sounds inside sound group
            printSoundGroups()
        }
    }
    
    private func deleteGroup(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(soundGroups[index]) // Deletes from SwiftData
        }
        try? modelContext.save()
    }
    
    private func printSoundGroups() {
        print("🎵 Available Sound Groups:")
        for group in soundGroups {
            print("- \(group.name) (Enabled: \(group.isEnabled))")
            if group.sounds.isEmpty {
                print("  - No sounds in this group")
            } else {
                for sound in group.sounds {
                    print("  - \(sound)")
                }
            }
        }
    }
}




