import SwiftUI
import SwiftData
import WatchKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel = SoundDetectionViewModel()
    @StateObject var iPhoneCommunicator: WatchToIOS
    @State private var activeSounds: [String] = []
    
    // Alert state
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    init(modelContext: ModelContext) {
        self._iPhoneCommunicator = StateObject(wrappedValue: WatchToIOS(modelContext: modelContext))
        NotificationHandler.shared.requestNotificationPermission()
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            if !viewModel.detectionStarted {
                VStack {
                    Image(systemName: "waveform.badge.magnifyingglass")
                        .font(.system(size: 40))
                    Text("No Sound Detected")
                        .font(.headline)
                }
                .padding()
            } else if let predictedSound = viewModel.identifiedSound {
                VStack(spacing: 5) {
                    Text(predictedSound.identifier)
                        .font(.title3)
                    Text("\(predictedSound.confidence) confidence")
                        .font(.caption)
                }
                .multilineTextAlignment(.center)
                .padding()
                .onChange(of: predictedSound.identifier) { newIdentifier in
                    notifyUserIfSoundIsActive(Utilities.displayNameToSound(predictedSound.identifier))
                }
            } else {
                ProgressView("Listening...")
            }
            Spacer()
            Button(action: {
                withAnimation {
                    viewModel.detectionStarted.toggle()
                }
                if viewModel.detectionStarted {
                    viewModel.startDetection()
                    iPhoneCommunicator.sendMessageToiPhone()
                } else {
                    viewModel.stopDetection()
                }
            }, label: {
                Image(systemName: viewModel.detectionStarted ? "stop.fill" : "mic.fill")
                    .font(.system(size: 30))
                    .padding()
                    .background(viewModel.detectionStarted ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            })
            .buttonStyle(.plain)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            print("Apple Watch App Starting")
        }
    }

    private func notifyUserIfSoundIsActive(_ identifier: String) {
        Task {
            let fetchDescriptor = FetchDescriptor<ActiveSounds>()
            if let activeSoundsModel = try? modelContext.fetch(fetchDescriptor).first {
                let activeSoundsDict = activeSoundsModel.sounds

                if let soundGroup = activeSoundsDict[identifier] {
                    print("🔔 Sound '\(Utilities.soundToDisplayName(identifier))' is active in group '\(soundGroup)'. Alerting user...")

                    // Haptic
                    WKInterfaceDevice.current().play(.notification)

                    // Show Alert
                    alertTitle = "Sound Detected"
                    alertMessage = "'\(Utilities.soundToDisplayName(identifier))' in group '\(soundGroup)'"
                    showAlert = true

                    // No need to schedule a system notification since app is in foreground
                } else {
                    print("❌ Sound '\(identifier)' is NOT in active sounds. No alert shown.")
                }
            } else {
                print("⚠️ No ActiveSounds data found in SwiftData.")
            }
        }
    }
}
