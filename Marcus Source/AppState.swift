import Foundation
import SwiftUI

final class AppState: ObservableObject {
    @Published var currentUser: User
    @Published var users: [User]
    @Published var challenges: [Challenge]
    @Published var entries: [Entry]
    @Published var messages: [Message]
    @Published var quotes: [Quote]

    init(seed: Bool = false) {
        // Step 1: initialize with placeholder values
        let placeholderUser = User(id: UUID().uuidString, name: "You", avatarColor: .blue)
        self.currentUser = placeholderUser
        self.users = []
        self.challenges = []
        self.entries = []
        self.messages = []
        self.quotes = []

        // Step 2: replace with seeded or default data
        if seed {
            let seeded = SeedData.make()
            self.currentUser = seeded.currentUser
            self.users       = seeded.users
            self.challenges  = seeded.challenges
            self.entries     = seeded.entries
            self.messages    = seeded.messages
            self.quotes      = seeded.quotes
        } else {
            self.users = [self.currentUser]
        }
    }

    // MARK: - Logging

    func log(eventKey: String, amount: Int, in challenge: Challenge, note: String? = nil) {
        guard let rule = challenge.rules.events.first(where: { $0.key == eventKey }) else { return }
        let points = rule.pointsFor(amount: amount)
        let e = Entry(
            id: UUID().uuidString,
            challengeId: challenge.id,
            userId: currentUser.id,
            eventKey: eventKey,
            amount: amount,
            points: points,
            at: Date(),
            note: note
        )
        entries.append(e)
        objectWillChange.send()
    }

    func messagesFor(challengeId: String) -> [Message] {
        messages
            .filter { $0.challengeId == challengeId }
            .sorted { $0.at < $1.at }
    }

    func entriesFor(challengeId: String) -> [Entry] {
        entries
            .filter { $0.challengeId == challengeId }
            .sorted { $0.at > $1.at }
    }

    func membersFor(challengeId: String) -> [User] {
        let ids = challenges.first { $0.id == challengeId }?.members ?? []
        return users.filter { ids.contains($0.id) }
    }

    func addMessage(_ text: String, challengeId: String) {
        let msg = Message(
            id: UUID().uuidString,
            challengeId: challengeId,
            userId: currentUser.id,
            text: text,
            at: Date()
        )
        messages.append(msg)
        objectWillChange.send()
    }

    // MARK: - Leaderboard

    func leaderboardTotals(for challenge: Challenge, in range: DateInterval?) -> [(User, Double)] {
        let mems = membersFor(challengeId: challenge.id)
        var out: [(User, Double)] = []
        for u in mems {
            let pts = entries
                .filter {
                    $0.challengeId == challenge.id &&
                    $0.userId == u.id &&
                    (range == nil || range!.contains($0.at))
                }
                .reduce(0.0) { $0 + $1.points }
            out.append((u, pts))
        }
        return out.sorted { $0.1 > $1.1 }
    }
}

// MARK: - Seeding

enum SeedData {
    static func make() -> (currentUser: User,
                           users: [User],
                           challenges: [Challenge],
                           entries: [Entry],
                           messages: [Message],
                           quotes: [Quote]) {
        let you  = User(id: "u-you",  name: "You",  avatarColor: .blue)
        let alex = User(id: "u-alex", name: "Alex", avatarColor: .green)
        let sam  = User(id: "u-sam",  name: "Sam",  avatarColor: .orange)

        let rules = RuleSet(events: [
            RuleEvent(key: "vigorous", label: "Workout (60m)", points: 1,  unit: .minute, threshold: 60,  mode: .discrete,     dailyCap: 3),
            RuleEvent(key: "pickle",   label: "Pickleball (120m)", points: 1, unit: .minute, threshold: 120, mode: .discrete,     dailyCap: 2),
            RuleEvent(key: "drink",    label: "Alcoholic drink",   points: -1, unit: .count,  threshold: 1,   mode: .discrete,     dailyCap: -10),
            RuleEvent(key: "smoke",    label: "Nicotine",          points: -1, unit: .count,  threshold: 1,   mode: .discrete,     dailyCap: -10)
        ], tieBreakers: [.daysWithPositive, .earliestTopScore, .fewestNegatives])

        let augReset = Challenge(
            id: "c-aug",
            name: "August Reset",
            ownerId: you.id,
            startAt: Date().addingTimeInterval(-3*86400),
            endAt:   Date().addingTimeInterval(12*86400),
            rules: rules,
            members: [you.id, alex.id, sam.id],
            status: .active
        )

        let entries: [Entry] = [
            Entry(id: "e1", challengeId: "c-aug", userId: you.id,  eventKey: "vigorous", amount: 60,  points:  1, at: Date().addingTimeInterval(-3600*2),  note: "Gym"),
            Entry(id: "e2", challengeId: "c-aug", userId: alex.id, eventKey: "drink",    amount: 1,   points: -1, at: Date().addingTimeInterval(-3600*3),  note: "Beer"),
            Entry(id: "e3", challengeId: "c-aug", userId: sam.id,  eventKey: "pickle",   amount: 120, points:  1, at: Date().addingTimeInterval(-3600*26), note: "Doubles")
        ]

        let msgs: [Message] = [
            Message(id: "m1", challengeId: "c-aug", userId: alex.id, text: "Let’s lock our logs by 9pm.", at: Date().addingTimeInterval(-3600*10)),
            Message(id: "m2", challengeId: "c-aug", userId: you.id,  text: "Deal. I’m hitting the gym now 💪", at: Date().addingTimeInterval(-3600*9)),
            Message(id: "m3", challengeId: "c-aug", userId: sam.id,  text: "Quote of the day was 🔥", at: Date().addingTimeInterval(-3600*6))
        ]

        let quotes = Quote.sample
        return (you, [you, alex, sam], [augReset], entries, msgs, quotes)
    }
}
