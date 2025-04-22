//
//  ReceivedDateModel.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 1/29/25.
//
import Foundation
import SwiftData

@Model class ReceivedDateModel {
    var receivedDate: Date

    init(receivedDate: Date) {
        self.receivedDate = receivedDate
    }
}

class ReceivedDateManager: ObservableObject {
    @Published var latestReceivedDate: Date?
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadLatestDate()
    }

    private func loadLatestDate() {
        do {
            let savedDates = try modelContext.fetch(FetchDescriptor<ReceivedDateModel>())
            if let lastDateEntry = savedDates.first {
                self.latestReceivedDate = lastDateEntry.receivedDate
            }
        } catch {
            print("Error loading received date: \(error)")
        }
    }

    func updateReceivedDate(_ newDate: Date) {
        // Remove previous date entry (only store one latest date)
        do {
            let savedDates = try modelContext.fetch(FetchDescriptor<ReceivedDateModel>())
            for entry in savedDates {
                modelContext.delete(entry)
            }
        } catch {
            print("Error clearing old date: \(error)")
        }

        // Save new date
        let newDateEntry = ReceivedDateModel(receivedDate: newDate)
        modelContext.insert(newDateEntry)
        saveContext()
        latestReceivedDate = newDate
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving received date: \(error)")
        }
    }
}
