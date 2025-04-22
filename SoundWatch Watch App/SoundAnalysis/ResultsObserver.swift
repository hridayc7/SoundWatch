//
//  ResultsObserver.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 10/30/24.
//


import SoundAnalysis
import Combine

class ResultsObserver: NSObject, SNResultsObserving {
    private let subject: PassthroughSubject<SNClassificationResult, Error>
    
    init(subject: PassthroughSubject<SNClassificationResult, Error>) {
        self.subject = subject
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        if let result = result as? SNClassificationResult {
            subject.send(result)
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \(error.localizedDescription)")
        subject.send(completion: .failure(error))
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
        subject.send(completion: .finished)
    }
}
