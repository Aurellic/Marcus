import SwiftUI

struct RulesView: View {
    let rules: RuleSet
    var body: some View {
        List {
            Section("Positive") { ForEach(rules.events.filter{ $0.points > 0 }) { e in ruleRow(e) } }
            Section("Negative") { ForEach(rules.events.filter{ $0.points < 0 }) { e in ruleRow(e) } }
        }.listStyle(.insetGrouped)
    }
    func ruleRow(_ e: RuleEvent) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(e.label).font(.headline)
                Text("Points: \(e.points >= 0 ? "+" : "")\(e.points), Threshold: \(e.threshold) \(e.unit == .minute ? "min" : "count"), Mode: \(e.mode.rawValue)").font(.caption).foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}
