import Foundation

struct Quote: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let author: String
    let licenseTag: String
    let tags: [String]
}

extension Quote {
    static let sample: [Quote] = [
        Quote(id: "q1", text: "You have power over your mind — not outside events.", author: "Marcus Aurelius", licenseTag: "PD", tags: ["stoic","mindset"]),
        Quote(id: "q2", text: "The impediment to action advances action.", author: "Marcus Aurelius", licenseTag: "PD", tags: ["stoic"]),
        Quote(id: "q3", text: "What you do every day matters more than what you do once in a while.", author: "Gretchen Rubin", licenseTag: "UserProvided", tags: ["habit"])
    ]
}
