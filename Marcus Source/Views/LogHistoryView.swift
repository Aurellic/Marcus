import SwiftUI

struct LogHistoryView: View {
    @EnvironmentObject var app: AppState
    var body: some View {
        List {
            Section("This Week") {
                ForEach(app.entries.sorted{ $0.at > $1.at }) { e in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(label(for: e)).font(.headline)
                            Text(e.at.formatted(date: .abbreviated, time: .shortened)).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(points(e.points)).bold()
                    }
                }
            }
        }.navigationTitle("History").listStyle(.insetGrouped)
    }
    func label(for e: Entry) -> String {
        switch e.eventKey {
        case "vigorous": return "+1 Workout (60m)"
        case "pickle": return "+1 Pickleball (120m)"
        case "drink": return "-1 Drink"
        case "smoke": return "-1 Smoke"
        default: return e.eventKey
        }
    }
    func points(_ p: Double) -> String { (p >= 0 ? "+" : "") + String(format: "%.0f", p) }
}
