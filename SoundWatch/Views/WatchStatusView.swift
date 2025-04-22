import Foundation
import SwiftData
import SwiftUI
import WatchConnectivity

struct WatchStatusView: View {
    @EnvironmentObject var watchConnector: WatchConnectivity
    // @EnvironmentObject var soundsManager: SoundsManager
    @EnvironmentObject var receivedDateManager: ReceivedDateManager
    @Query private var soundGroups: [SoundGroup] // Fetch sound groups

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Check if the Watch app is installed
            if !watchConnector.isAppleWatchAppInstalled {
                Image(systemName: "exclamationmark.applewatch")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                Text("Please install the Watch app")
                    .font(.headline)
            } else {
                if watchConnector.isConnectedToWatch {
                    Text("Apple Watch is Connected")
                        .font(.headline)
                        .foregroundColor(.green)

                    Button(action: {
                        watchConnector.sendSoundGroupsToWatch(soundGroups: soundGroups)
                        print("Sync triggered")
                    }) {
                        Text("Sync Now")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                } else {
                    Text("Apple Watch is not connected.")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                
                if let lastSyncDate = receivedDateManager.latestReceivedDate {
                    Text("Last Sync: \(formattedDate(lastSyncDate))")
                        .font(.caption)
                        .padding()
                } else {
                    Text("No Sync Yet")
                        .font(.caption)
                        .padding()
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            watchConnector.sendSoundGroupsToWatch(soundGroups: soundGroups)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

//struct WatchStatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        WatchStatusView()
//            .environmentObject(WatchConnectivity(receivedDateManager: ReceivedDateManager(modelContext: ModelContext(ModelContainer(for: ReceivedDateModel.self)))))
//            .environmentObject(SoundsManager(modelContext: ModelContext(ModelContainer(for: SoundsModel.self))))
//            .environmentObject(ReceivedDateManager(modelContext: ModelContext(ModelContainer(for: ReceivedDateModel.self))))
//    }
//}
