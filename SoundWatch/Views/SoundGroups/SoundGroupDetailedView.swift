//
//  SoundGroupDetailedView.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 2/26/25.
//
// View for each individual sound group ... shows you which sounds are added to a particular group

import SwiftUI

struct SoundGroupDetailedView: View {
    @Bindable var soundGroup: SoundGroup
    @State private var showingAddSound = false
    
    var body: some View {
        List {
            ForEach(soundGroup.sounds, id: \ .self) { sound in
                Text(Utilities.soundToDisplayName(sound))
            }
            .onDelete(perform: deleteSound)
        }
        .navigationTitle(soundGroup.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddSound = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSound) {
            AddNewSoundView(soundGroup: soundGroup)
        }
    }
    
    private func deleteSound(at offsets: IndexSet) {
        for index in offsets {
            soundGroup.sounds.remove(at: index)
        }
        try? soundGroup.modelContext?.save()
    }
}


