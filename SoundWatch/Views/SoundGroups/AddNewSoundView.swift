import SwiftUI
import SwiftData

// ✅ Wrapper View (Keeps the same name so no need to update other files)
struct AddNewSoundView: View {
    @Bindable var soundGroup: SoundGroup
    
    var body: some View {
        SoundCategoriesView(soundGroup: soundGroup)
    }
}

// ✅ FIRST VIEW: Displays main categories
struct SoundCategoriesView: View {
    @Bindable var soundGroup: SoundGroup
    @State private var soundsToAdd: Set<String> = [] // Holds selected sounds
    @Environment(\.dismiss) var dismiss
    
    /// Grouped Sounds: All 300+ Sound Classes from the SoundAnalysis Class
    let groupedSounds: [String: [String: [String]]] = [
        "Human Sounds": [
            "Speech & Vocalizations": ["speech", "shout", "yell", "battle_cry", "children_shouting", "screaming", "whispering", "laughter", "baby_laughter", "giggling", "snicker", "belly_laugh", "chuckle_chortle", "crying_sobbing", "baby_crying", "sigh", "singing", "choir_singing", "yodeling", "rapping", "humming", "whistling"],
            "Breathing & Reactions": ["breathing", "snoring", "gasp", "cough", "sneeze", "nose_blowing"],
            "Hand & Foot Actions": ["person_running", "person_shuffling", "person_walking", "finger_snapping", "clapping", "cheering", "applause", "booing"],
            "Bodily Noises": ["chewing", "biting", "gargling", "burp", "hiccup", "slurp"]
        ],
        "Crowds & Groups": [
            "General Crowds": ["chatter", "crowd", "babble"]
        ],
        "Animal Sounds": [
            "Domestic Animals": ["dog", "dog_bark", "dog_howl", "dog_bow_wow", "dog_growl", "dog_whimper", "cat", "cat_purr", "cat_meow", "horse_clip_clop", "horse_neigh", "cow_moo", "pig_oink", "sheep_bleat"],
            "Fowl": ["chicken", "chicken_cluck", "rooster_crow", "turkey_gobble", "duck_quack", "goose_honk"],
            "Wild Animals": ["lion_roar", "coyote_howl", "elk_bugle"],
            "Bird Sounds": ["bird", "bird_vocalization", "bird_chirp_tweet", "bird_squawk", "pigeon_dove_coo", "crow_caw", "owl_hoot", "bird_flapping"],
            "Insects & Amphibians": ["insect", "cricket_chirp", "mosquito_buzz", "fly_buzz", "bee_buzz", "frog", "frog_croak", "snake_hiss", "snake_rattle"],
            "Marine Animals": ["whale_vocalization"]
        ],
        "Musical Sounds": [
            "String Instruments": ["plucked_string_instrument", "guitar", "electric_guitar", "bass_guitar", "acoustic_guitar", "steel_guitar_slide_guitar", "guitar_tapping", "guitar_strum", "banjo", "sitar", "mandolin", "zither", "ukulele"],
            "Keyboard Instruments": ["keyboard_musical", "piano", "electric_piano", "organ", "electronic_organ", "hammond_organ", "synthesizer", "harpsichord"],
            "Percussion Instruments": ["percussion", "drum_kit", "drum", "snare_drum", "bass_drum", "timpani", "tabla", "cymbal", "hi_hat", "tambourine", "rattle_instrument", "gong", "mallet_percussion", "marimba_xylophone", "glockenspiel", "vibraphone", "steelpan"],
            "Orchestral Instruments": ["orchestra", "brass_instrument", "french_horn", "trumpet", "trombone", "bowed_string_instrument", "violin_fiddle", "cello", "double_bass"],
            "Wind Instruments": ["wind_instrument", "flute", "saxophone", "clarinet", "oboe", "bassoon"],
            "Other Instruments": ["harp", "harmonica", "accordion", "bagpipes", "didgeridoo", "shofar", "theremin", "singing_bowl"],
            "Bells & Chimes": ["bell", "church_bell", "bicycle_bell", "cowbell", "tuning_fork", "chime", "wind_chime"]
        ],
        "Natural Sounds": [
            "Weather & Wind": ["wind", "wind_rustling_leaves", "wind_noise_microphone", "thunderstorm", "thunder"],
            "Water Sounds": ["water", "rain", "raindrop", "stream_burbling", "waterfall", "ocean", "sea_waves", "gurgling"],
            "Fire Sounds": ["fire", "fire_crackle"]
        ],
        "Vehicles & Transport": [
            "Water Vehicles": ["boat_water_vehicle", "sailing", "rowboat_canoe_kayak", "motorboat_speedboat"],
            "Land Vehicles": ["car_horn", "power_windows", "vehicle_skidding", "car_passing_by", "race_car", "truck", "air_horn", "reverse_beeps", "bus"],
            "Emergency Vehicles": ["emergency_vehicle", "police_siren", "ambulance_siren", "fire_engine_siren"],
            "Trains & Subways": ["rail_transport", "train", "train_whistle", "train_horn", "railroad_car", "train_wheels_squealing", "subway_metro"],
            "Aircraft": ["aircraft", "helicopter", "airplane"],
            "Other": ["bicycle", "skateboard"]
        ],
        "Household & Everyday Sounds": [
            "Doors & Windows": ["door", "door_bell", "door_sliding", "door_slam", "knock", "tap", "squeak", "drawer_open_close"],
            "Kitchen Sounds": ["dishes_pots_pans", "cutlery_silverware", "chopping_food", "frying_food", "microwave_oven", "blender"],
            "Bathroom Sounds": ["water_tap_faucet", "sink_filling_washing", "bathtub_filling_washing", "hair_dryer", "toilet_flush", "toothbrush"],
            "Cleaning & Appliances": ["vacuum_cleaner", "zipper", "keys_jangling", "coin_dropping", "scissors", "electric_shaver"],
            "Office & Typing": ["typing", "typewriter", "typing_computer_keyboard", "writing", "telephone", "telephone_bell_ringing", "ringtone", "alarm_clock"],
            "Alarms & Sirens": ["siren", "civil_defense_siren", "smoke_detector", "foghorn"],
            "Clocks & Timepieces": ["clock", "tick", "tick_tock"],
            "Mechanical & Electrical": ["sewing_machine", "mechanical_fan", "air_conditioner", "printer", "camera"],
            "Tools & Construction": ["hammer", "saw", "power_tool", "drill", "hedge_trimmer"],
            "Explosions & Fireworks": ["gunshot_gunfire", "artillery_fire", "fireworks", "firecracker", "eruption", "boom"],
            "Wood & Glass": ["chopping_wood", "wood_cracking", "glass_clink", "glass_breaking"],
            "Liquids & Bubbling": ["liquid_splashing", "liquid_sloshing", "liquid_squishing", "liquid_dripping", "liquid_pouring", "liquid_trickle_dribble", "liquid_filling_container", "liquid_spraying", "water_pump", "boiling", "underwater_bubbling"]
        ],
        "Miscellaneous Sounds": [
            "Movement & Impact": ["whoosh_swoosh_swish", "thump_thud", "basketball_bounce", "slap_smack", "crushing", "crumpling_crinkling", "tearing"],
            "Electronic Beeps & Clicks": ["beep", "click"],
            "Sports & Games": ["bowling_impact", "playing_badminton", "playing_hockey", "playing_squash", "playing_table_tennis", "playing_tennis", "playing_volleyball", "rope_skipping", "scuba_diving", "skiing"],
            "Silence": ["silence"]
        ]
    ]
    
    var body: some View {
        VStack{
            Text(soundsToAdd.isEmpty ? " " : "\(soundsToAdd.count) sound(s) added to \(soundGroup.name)")
                .font(.caption)
                .padding(.top, 5)
                .foregroundColor(.secondary)
            NavigationView {
                VStack {
                    List {
                        ForEach(groupedSounds.keys.sorted(), id: \..self) { category in
                            NavigationLink(destination: SoundSelectionView(soundGroup: soundGroup, category: category, subcategories: groupedSounds[category]!, soundsToAdd: $soundsToAdd)) {
                                Text(category)
                                    .font(.headline)
                                    .padding(5)
                            }
                        }
                    }
                }
                .navigationTitle("Select Sound Category")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            if !soundsToAdd.isEmpty {
                                soundGroup.sounds.append(contentsOf: soundsToAdd.filter { !soundGroup.sounds.contains($0) })
                                try? soundGroup.modelContext?.save()
                            }
                            dismiss()
                        }
                        .disabled(soundsToAdd.isEmpty)
                    }
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
}

// ✅ SECOND VIEW: Displays subcategories and their sounds
struct SoundSelectionView: View {
    @Bindable var soundGroup: SoundGroup
    let category: String
    let subcategories: [String: [String]]
    @Binding var soundsToAdd: Set<String> // Shared state to persist selections
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            List {
                ForEach(subcategories.keys.sorted(), id: \..self) { subcategory in
                    Section(header: Text(subcategory).font(.headline)) {
                        ForEach(subcategories[subcategory]!, id: \..self) { sound in
                            HStack {
                                Text(sound.replacingOccurrences(of: "_", with: " ").capitalized)
                                Spacer()
                                Button(action: {
                                    if soundsToAdd.contains(sound) {
                                        soundsToAdd.remove(sound)
                                    } else {
                                        soundsToAdd.insert(sound)
                                    }
                                }) {
                                    Image(systemName: soundsToAdd.contains(sound) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(soundsToAdd.contains(sound) ? .green : .gray)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(category)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}



// ✅ PREVIEW: Uses a mock SoundGroup
//struct AddNewSoundView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatefulPreviewWrapperTwo(SoundGroup(name: "Home", isEnabled: true, sounds: [])) { binding in
//            AddNewSoundView(soundGroup: binding)
//        }
//    }
//}

// ✅ Helper for Binding-based previews
struct StatefulPreviewWrapperTwo<Value, Content: View>: View {
    @State private var value: Value
    let content: (Binding<Value>) -> Content
    
    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: value)
        self.content = content
    }
    
    var body: some View {
        content($value)
    }
}
