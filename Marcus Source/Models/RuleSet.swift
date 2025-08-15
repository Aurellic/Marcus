import Foundation

struct RuleSet: Codable, Hashable {
    var events: [RuleEvent]
    var tieBreakers: [TieBreaker]
    enum TieBreaker: String, Codable { case daysWithPositive, earliestTopScore, fewestNegatives }
}

struct RuleEvent: Identifiable, Codable, Hashable {
    var id: String { key }
    let key: String
    let label: String
    let points: Int
    let unit: Unit
    let threshold: Int
    let mode: Mode
    let dailyCap: Int?
    enum Unit: String, Codable { case minute, count }
    enum Mode: String, Codable { case discrete, proportional }
    func pointsFor(amount: Int) -> Double {
        switch mode {
        case .discrete: return Double(amount / max(1, threshold) * points)
        case .proportional: return (Double(amount) / Double(max(1, threshold))) * Double(points)
        }
    }
}
