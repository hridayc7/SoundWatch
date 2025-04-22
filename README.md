# SoundWatch

SoundWatch is an Apple Watch application that uses the built-in microphone to detect and alert users about sounds in their environment. It works with a companion iPhone app to customize which sounds to monitor.

## Overview

SoundWatch leverages Apple's Sound Analysis framework to identify various sounds in real-time. Users can:

- Organize sounds into customizable groups via the iPhone app
- Receive alerts on their Apple Watch when specific sounds are detected
- View a list of active sound groups and individual sounds on the watch

## Key Features

- **Real-time sound detection** using Apple's Sound Analysis framework
- **Sound grouping system** to organize sounds by category (e.g., "Home", "Office", "Emergency")
- **Customizable alerts** for different sound types
- **Bidirectional communication** between iPhone and Apple Watch
- **Persistent storage** using SwiftData
- **Background detection** (in development)

## Project Structure

### Watch App Components

- **Sound Analysis**: Core functionality for detecting and classifying sounds
  - `SoundAnalysisManager.swift`: Manages audio capture and analysis
  - `ResultsObserver.swift`: Handles classification results
  - `SoundDetectionViewModel.swift`: Manages sound detection state

- **Data Management**:
  - `ActiveSounds.swift`: SwiftData model for storing active sounds
  - `WatchToIOS.swift`: Handles communication with the iPhone

- **User Interface**:
  - `ContentView.swift`: Main Watch app interface with sound detection status
  - `ActiveSoundsView.swift`: Displays currently active sounds

### iPhone App Components

- **Data Models**:
  - `SoundGroup.swift`: SwiftData model for organizing sounds into groups
  - `ReceivedDateModel.swift`: Tracks synchronization timestamps

- **Views**:
  - `SoundGroupView.swift`: Lists all sound groups
  - `SoundGroupDetailedView.swift`: Shows sounds within a group
  - `AddNewSoundView.swift`: Interface for adding sounds to groups
  - `WatchStatusView.swift`: Shows Apple Watch connection status

- **Communication**:
  - `WatchConnectivity.swift`: Manages messaging between iPhone and Watch

## Technical Details

- **Frameworks**: SwiftUI, SwiftData, WatchConnectivity, SoundAnalysis
- **Minimum Requirements**:
  - iOS 17.6+ for iPhone app
  - watchOS 10.6+ for Watch app

## Setup Instructions

1. **Prerequisites**:
   - Xcode 16.0 or later
   - iOS device running iOS 17.6+
   - Apple Watch running watchOS 10.6+
   - Apple Developer account for testing on physical devices

2. **Getting Started**:
   - Clone the repository
   - Open `SoundWatch.xcodeproj` in Xcode
   - Select your team in the Signing & Capabilities section for both the iPhone and Watch targets
   - Build and run the iPhone app on your iPhone
   - The Watch app should automatically install on your paired Apple Watch

3. **Configuration**:
   - Grant microphone permissions when prompted
   - Create sound groups in the iPhone app
   - Enable desired sound groups
   - Sync with your Apple Watch using the "Sync Now" button

## Troubleshooting

### Common Issues

- **Watch app not receiving updates**: Ensure Bluetooth is enabled and devices are in range
- **Sound detection not working**: Check microphone permissions and ensure the detection is started
- **Sync failures**: Try restarting both the iPhone and Watch apps

### Debug Information

- Set breakpoints in the `WatchToIOS.swift` and `WatchConnectivity.swift` files to troubleshoot communication issues
- Monitor console logs for "❌" symbols indicating errors in the application

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[Insert your license information here]
