import Foundation
import SwiftUI

struct User: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var avatarColor: ColorName
    
    var initials: String {
        let parts = name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? "U"
        let last  = parts.dropFirst().first?.first.map(String.init) ?? ""
        return (first + last).uppercased()
    }
}

enum ColorName: String, Codable, CaseIterable {
    case blue, green, orange, purple, teal, pink, gray
    var color: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .orange: return .orange
        case .purple: return .purple
        case .teal: return .teal
        case .pink: return .pink
        case .gray: return .gray
        }
    }
}
