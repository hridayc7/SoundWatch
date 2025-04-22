//
//  SoundAnalysisManager.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 10/30/24.
//


import SoundAnalysis
import AVFoundation
import Combine

final class SoundAnalysisManager: NSObject {
    private let bufferSize = 8192
    private var audioEngine: AVAudioEngine?
    private var inputBus: AVAudioNodeBus = 0
    private var inputFormat: AVAudioFormat?
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private let analysisQueue = DispatchQueue(label: "com.createwithswift.AnalysisQueue")
    private var retainedObserver: SNResultsObserving?
    private var subject: PassthroughSubject<SNClassificationResult, Error>?
    
    static let shared = SoundAnalysisManager()
    
    private override init() {}
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputBus = AVAudioNodeBus(0)
        
        // Configure the audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
        
        // Get the input format
        inputFormat = audioEngine?.inputNode.inputFormat(forBus: inputBus)
        guard let format = inputFormat, format.channelCount > 0, format.sampleRate > 0 else {
            print("Invalid audio format: \(String(describing: inputFormat))")
            return
        }
    }
    
    func startAnalysis(_ requestAndObserver: (request: SNRequest, observer: SNResultsObserving)) throws {
        setupAudioEngine()
        
        guard let audioEngine = audioEngine,
              let inputFormat = inputFormat else { return }
        
        let streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
        self.streamAnalyzer = streamAnalyzer
        
        try streamAnalyzer.add(requestAndObserver.request, withObserver: requestAndObserver.observer)
        
        retainedObserver = requestAndObserver.observer
        
        audioEngine.inputNode.installTap(
            onBus: inputBus,
            bufferSize: AVAudioFrameCount(bufferSize),
            format: inputFormat
        ) { buffer, time in
            self.analysisQueue.async {
                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }
    
    func startSoundClassification(subject: PassthroughSubject<SNClassificationResult, Error>,
                                  inferenceWindowSize: Double? = nil,
                                  overlapFactor: Double? = nil) {
        do {
            let observer = ResultsObserver(subject: subject)
            let version1 = SNClassifierIdentifier.version1
            let request = try SNClassifySoundRequest(classifierIdentifier: version1)
            
            if let inferenceWindowSize = inferenceWindowSize {
                request.windowDuration = CMTimeMakeWithSeconds(inferenceWindowSize, preferredTimescale: 48_000)
            }
            if let overlapFactor = overlapFactor {
                request.overlapFactor = overlapFactor
            }
            
            self.subject = subject
            try startAnalysis((request, observer))
            
            // TODO: Delete
            print("🔊 Available Sound Classes:")
            print(request.knownClassifications.joined(separator: ", "))
            
            
        } catch {
            print("Unable to prepare request with Sound Classifier: \(error.localizedDescription)")
            subject.send(completion: .failure(error))
            self.subject = nil
        }
    }
    
    func stopSoundClassification() {
        autoreleasepool {
            if let audioEngine = audioEngine {
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
            }
            if let streamAnalyzer = streamAnalyzer {
                streamAnalyzer.removeAllRequests()
            }
            streamAnalyzer = nil
            retainedObserver = nil
            audioEngine = nil
        }
    }
}
