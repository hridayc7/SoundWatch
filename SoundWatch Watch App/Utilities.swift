//
//  Utilities.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 3/2/25.
//


//
//  SoundFormatter.swift
//  SoundWatch
//
//  Created by Hriday Chhabria on 2/26/25.
//
import Foundation

///Utlities: A Class that contains static helper funtions used across the entire project
class Utilities {
    /// Converts internal sound names (e.g., "water_pump") to display-friendly names (e.g., "Water Pump")
    static func soundToDisplayName(_ sound: String) -> String {
        return sound.replacingOccurrences(of: "_", with: " ").capitalized
    }

    /// Converts display-friendly names (e.g., "Water Pump") back to internal sound names (e.g., "water_pump")
    static func displayNameToSound(_ displayName: String) -> String {
        return displayName.lowercased().replacingOccurrences(of: " ", with: "_")
    }
}
