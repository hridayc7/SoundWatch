////
////  EmergencySounds.swift
////  SoundWatch
////
////  Created by Hriday Chhabria on 11/11/24.
////
//// TODO - Delete
//
//import SwiftUI
//
//struct HighAlertSoundsView: View {
//    
//    @EnvironmentObject var soundsManager: SoundsManager
//
//    var body: some View {
//        VStack {
//            // Emergency icon and title
//            Image(systemName: "exclamationmark.triangle.fill")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 100, height: 100)
//                .foregroundColor(.red)
//                .padding(.top, 50)
//            
//            Text("Emergency Sounds")
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(.red)
//                .padding(.top, 20)
//            
//            // List of sound options with toggles
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Select Sounds")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.leading)
//                    .padding(.top, 20)
//                
//                soundToggle(for: "Emergency Vehicle")
//                Divider()
//                
//                soundToggle(for: "Police Siren")
//                Divider()
//                
//                soundToggle(for: "Ambulance Siren")
//                Divider()
//                
//                soundToggle(for: "Fire Engine Siren")
//                Divider()
//                
//                soundToggle(for: "Glass Breaking")
//                Divider()
//                
//                soundToggle(for: "Gunshot Gunfire")
//                Divider()
//                
//                soundToggle(for: "Artillery Fire")
//                Divider()
//                
//                soundToggle(for: "Smoke Detector")
//                Divider()
//                
//                
//            }
//            .background(Color(UIColor.systemBackground)) // Matches the system background color
//            .cornerRadius(10)
//            .padding(.top, 20)
//            .padding(.horizontal, 16)
//            
//            Spacer()
//        }
//        .navigationTitle("High Alert Sounds")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//    
//    // Reusable function to create a toggle for a given sound
//    private func soundToggle(for soundName: String) -> some View {
//        Toggle(soundName, isOn: Binding(
//            get: { soundsManager.sounds.contains(soundName) },
//            set: { isOn in
//                isOn ? soundsManager.addSound(soundName) : soundsManager.removeSound(soundName)
//            }
//        ))
//        .padding(.horizontal)
//    }
//}
//
