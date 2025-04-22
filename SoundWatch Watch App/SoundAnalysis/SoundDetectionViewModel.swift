//
//  SoundDetectionViewModel.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 10/30/24.
//


import Combine
import SoundAnalysis
import AVFoundation

class SoundDetectionViewModel: ObservableObject {
    @Published var activatedSounds: [String] = []
    @Published var detectionStarted = false {
        didSet {
            // Handle any state changes if needed
        }
    }
    @Published var identifiedSound: (identifier: String, confidence: String)?
    
    private let soundAnalysisManager = SoundAnalysisManager.shared
    private var lastTime: Double = 0
    private var detectionCancellable: AnyCancellable?
    
    private func formattedDetectionResult(_ result: SNClassificationResult) -> (identifier: String, confidence: String)? {
        guard let classification = result.classifications.first else { return nil }
        
        if lastTime == 0 {
            lastTime = result.timeRange.start.seconds
        }
        
        let formattedTime = String(format: "%.2f", result.timeRange.start.seconds - lastTime)
        print("Analysis result for audio at time: \(formattedTime)")
        
        let displayName = classification.identifier.replacingOccurrences(of: "_", with: " ").capitalized
        let confidence = classification.confidence
        let confidencePercentString = String(format: "%d%%", Int(round(confidence * 100.0)))
        print("\(displayName): \(confidencePercentString) confidence.\n")
        
        return (displayName, confidencePercentString)
    }
    
    func startDetection() {
        let classificationSubject = PassthroughSubject<SNClassificationResult, Error>()
        
        detectionCancellable = classificationSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in self.detectionStarted = false },
                  receiveValue: { result in
                let sound = self.formattedDetectionResult(result)
                self.identifiedSound = sound
            })
        
        soundAnalysisManager.startSoundClassification(subject: classificationSubject)
    }
    
    func stopDetection() {
        lastTime = 0
        identifiedSound = nil
        soundAnalysisManager.stopSoundClassification()
    }
    
    func updateSoundClassificationLists(sound: String){
        activatedSounds.append(sound)
        print(activatedSounds)
    }
}
