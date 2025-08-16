import SwiftUI

/// App contexts that should influence which Marcus image we show.
enum MarcusMood: String {
    case neutral        // default / generic
    case encouraging    // after completing a challenge
    case reflective     // on quotes / journaling screens
    case celebratory    // streaks, achievements
    case empathetic     // user logs stress/low mood
    case focused        // during tasks, timers, exercises
    case thinking       // loading / processing states
}

/// Register your asset names here.
/// Add multiple variants per mood if you have them; the picker will randomize.
// Register your asset names here (use exact asset names)
private let marcusRegistry: [MarcusMood: [String]] = [
    MarcusMood.neutral:      ["CopilotThoughtful"],
    MarcusMood.encouraging:  ["CopilotThumbs", "CopilotWave"],
    MarcusMood.reflective:   ["CopilotPensive", "CopilotThoughtful"],
    MarcusMood.celebratory:  ["CopilotAwe", "CopilotWeird", "CopilotWild"],
    MarcusMood.empathetic:   ["CopilotDisappointed", "CopilotDespair"],
    MarcusMood.focused:      ["CopilotSarcasticThinking", "CopilotThoughtful"],
    MarcusMood.thinking:     ["CopilotSarcasticThinking", "CopilotPensive"]
]

/// Safely pick an image name for a given mood. Falls back to neutral if missing.
func marcusImageName(for mood: MarcusMood) -> String {
    let pool = marcusRegistry[mood] ?? marcusRegistry[ .neutral ] ?? []
    return pool.randomElement() ?? "MarcusNeutral"
}

/// Simple SwiftUI view to display the mood image.
/// Usage: MarcusMoodImage(.encouraging, size: 120)
struct MarcusMoodImage: View {
    let mood: MarcusMood
    var size: CGFloat = 120

    var body: some View {
        Image(marcusImageName(for: mood))
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

//  MarcusMood.swift
//  Marcus
//
//  Created by Russell Linsky on 8/15/25.
//

