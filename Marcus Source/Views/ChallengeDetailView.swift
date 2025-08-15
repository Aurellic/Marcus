import SwiftUI

struct ChallengeDetailView: View {
    @EnvironmentObject var app: AppState
    let challenge: Challenge

    @State private var tab: Tab = .feed
    @State private var showQuickLog = false

    enum Tab: String, CaseIterable { case feed = "Feed", leaderboard = "Leaderboard", rules = "Rules" }
// Test commit2 from Xcode
    var body: some View {
        VStack(spacing: 0) {
            // Tabs
            HStack(spacing: 8) {
                ForEach(Tab.allCases, id: \.self) { t in
                    Button { tab = t } label: {
                        Text(t.rawValue)
                            .font(.subheadline.bold())
                            .foregroundColor(tab == t ? .white : .primary)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(tab == t ? Color.accentColor : Color(.secondarySystemBackground))
                            )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)

            // Content
            Group {
                switch tab {
                case .feed:
                    ChallengeFeedView(challenge: challenge)
                case .leaderboard:
                    LeaderboardView(challenge: challenge)          // ✅ passes the challenge in
                case .rules:
                    RulesView(rules: challenge.rules)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle(challenge.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Quick Log") { showQuickLog = true }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink { ChatView(challenge: challenge) } label: {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                }
            }
        }
        .sheet(isPresented: $showQuickLog) {
            QuickLogSheet(challenge: challenge)
                .presentationDetents([.medium])
        }
    }
}

struct ChallengeFeedView: View {
    @EnvironmentObject var app: AppState
    let challenge: Challenge

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(app.entriesFor(challengeId: challenge.id)) { e in
                    EntryRow(entry: e)
                }
            }
            .padding()
        }
    }
}

struct EntryRow: View {
    @EnvironmentObject var app: AppState
    let entry: Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            let user = app.users.first { $0.id == entry.userId }?.name ?? "User"
            Text("\(formatPoints(entry.points)) \(labelForKey(entry.eventKey))")
                .font(.headline)
            Text("\(user) • \(entry.at.formatted(date: .abbreviated, time: .shortened))")
                .foregroundColor(.secondary)
                .font(.footnote)
            ProgressView(value: min(1.0, abs(entry.points) / 3.0))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }

    func formatPoints(_ p: Double) -> String { (p >= 0 ? "+" : "") + String(format: "%.0f", p) }

    func labelForKey(_ key: String) -> String {
        switch key {
        case "vigorous": return "Workout (60m)"
        case "pickle":   return "Pickleball (120m)"
        case "drink":    return "Drink"
        case "smoke":    return "Smoke"
        default:         return key
        }
    }
}
