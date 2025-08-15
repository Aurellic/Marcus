import SwiftUI

struct CreateChallengeWizard: View {
    @EnvironmentObject var app: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var step: Int = 1
    @State private var name: String = "August Reset"
    @State private var startAt: Date = Date()
    @State private var endAt: Date = Calendar.current.date(byAdding: .day, value: 14, to: Date())!
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) { Text("Step \(step) of 4").foregroundColor(.secondary).font(.caption); ProgressView(value: Double(step)/4.0) }
                switch step {
                case 1: stepName
                case 2: stepDates
                case 3: stepRules
                default: stepInvite
                }
                Spacer()
                HStack {
                    if step > 1 { Button("Back") { step -= 1 }.buttonStyle(.bordered) }
                    Spacer()
                    Button(step == 4 ? "Create" : "Next") { if step < 4 { step += 1 } else { create() } }.buttonStyle(.borderedProminent)
                }
            }.padding().navigationTitle("Create Challenge")
        }
    }
    var stepName: some View { VStack(alignment: .leading, spacing: 12) { Text("Name").font(.headline); TextField("Challenge name", text: $name).textFieldStyle(.roundedBorder) } }
    var stepDates: some View { VStack(alignment: .leading, spacing: 12) { Text("Dates").font(.headline); DatePicker("Start", selection: $startAt, displayedComponents: [.date]); DatePicker("End", selection: $endAt, displayedComponents: [.date]) } }
    var stepRules: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rules").font(.headline)
            Text("Using defaults: +1 for 60m workout, +1 for 120m pickleball, −1 per drink, −1 per smoke").font(.caption).foregroundColor(.secondary)
            RulesView(rules: defaultRules).frame(height: 240)
        }
    }
    var stepInvite: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Invite (local-only)").font(.headline)
            Text("In this local MVP, members are your three seed users. We’ll add real invites when we wire Firebase.").font(.caption).foregroundColor(.secondary)
            ForEach(app.users) { u in HStack { AvatarView(user: u).frame(width: 28, height: 28); Text(u.name); Spacer(); Image(systemName: "checkmark.circle.fill").foregroundColor(.green) } }
        }
    }
    var defaultRules: RuleSet {
        RuleSet(events: [
            RuleEvent(key: "vigorous", label: "Workout (60m)", points: 1, unit: .minute, threshold: 60, mode: .discrete, dailyCap: 3),
            RuleEvent(key: "pickle", label: "Pickleball (120m)", points: 1, unit: .minute, threshold: 120, mode: .discrete, dailyCap: 2),
            RuleEvent(key: "drink", label: "Alcoholic drink", points: -1, unit: .count, threshold: 1, mode: .discrete, dailyCap: -10),
            RuleEvent(key: "smoke", label: "Nicotine", points: -1, unit: .count, threshold: 1, mode: .discrete, dailyCap: -10)
        ], tieBreakers: [.daysWithPositive, .earliestTopScore, .fewestNegatives])
    }
    func create() {
        let c = Challenge(id: UUID().uuidString, name: name, ownerId: app.currentUser.id, startAt: startAt, endAt: endAt, rules: defaultRules, members: app.users.map{$0.id}, status: .active)
        app.challenges.append(c)
        dismiss()
    }
}
