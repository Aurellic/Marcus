import Foundation

struct Message: Identifiable, Codable, Hashable {
    let id: String
    let challengeId: String
    let userId: String
    let text: String
    let at: Date
}
