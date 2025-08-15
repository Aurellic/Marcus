import Foundation

struct Challenge: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var ownerId: String
    var startAt: Date
    var endAt: Date?
    var rules: RuleSet
    var members: [String]
    var status: Status
    
    enum Status: String, Codable { case active, pending, finished }
}
