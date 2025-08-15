import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var app: AppState
    let challenge: Challenge

    @State private var period: Period = .week
    enum Period: String, CaseIterable { case week = "This Week", all = "All Time" }

    var body: some View {
        VStack(alignment: .leading) {
            Picker("Period", selection: $period) {
                ForEach(Period.allCases, id: \.self) { p in
                    Text(p.rawValue).tag(p)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            List {
                // ✅ Give ForEach a stable ID (the User.id inside the tuple)
                ForEach(app.leaderboardTotals(for: challenge, in: periodInterval()), id: \.0.id) { pair in
                    HStack {
                        AvatarView(user: pair.0).frame(width: 28, height: 28)
                        VStack(alignment: .leading) {
                            Text(pair.0.name).font(.headline)
                            Text(daysWithPositive(userId: pair.0.id))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(pts(pair.1)).bold()
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }

    func periodInterval() -> DateInterval? {
        switch period {
        case .week:
            let cal = Calendar.current
            let start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            let end = cal.date(byAdding: .day, value: 7, to: start)!
            return DateInterval(start: start, end: end)
        case .all:
            return nil
        }
    }

    func pts(_ v: Double) -> String { (v >= 0 ? "+" : "") + String(format: "%.0f", v) }

    func daysWithPositive(userId: String) -> String {
        let positives = app.entries.filter {
            $0.challengeId == challenge.id && $0.userId == userId && $0.points > 0
        }
        let byDay = Dictionary(grouping: positives) { Calendar.current.startOfDay(for: $0.at) }
        return "\(byDay.keys.count) days with ≥1 point"
    }
}
