import Foundation

struct Entry: Identifiable, Codable {
    var id: String
    var challengeId: String
    var userId: String
    var eventKey: String
    var amount: Int
    var points: Double
    var at: Date
    var note: String?
}
