import SwiftUI

struct QuickLogSheet: View {
    @EnvironmentObject var app: AppState
    let challenge: Challenge
    @Environment(\ .dismiss) private var dismiss
    @State private var note: String = ""
    @State private var time: Date = Date()
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add Activity").font(.title3.bold())
            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    LogTile(title: "Workout\n60m", points: "+1") { log("vigorous", 60) }
                    LogTile(title: "Pickle\n120m", points: "+1") { log("pickle", 120) }
                    LogTile(title: "Drink", points: "−1", color: .red) { log("drink", 1) }
                }
                GridRow {
                    LogTile(title: "Smoke", points: "−1", color: .red) { log("smoke", 1) }
                    LogTile(title: "Custom", points: "⋯") { log("vigorous", 60) }
                }
            }
            DatePicker("Time", selection: $time, displayedComponents: [.date, .hourAndMinute]).datePickerStyle(.compact)
            TextField("Note (optional)", text: $note).textFieldStyle(.roundedBorder)
            Button { dismiss() } label: {
                Text("Close").frame(maxWidth: .infinity).padding().background(Color.accentColor.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 10))
            }.padding(.top, 4)
        }.padding()
    }
    func log(_ key: String, _ amount: Int) {
        app.log(eventKey: key, amount: amount, in: challenge, note: note.isEmpty ? nil : note)
    }
}

struct LogTile: View {
    let title: String; let points: String; var color: Color = .accentColor; var action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                Text(title).font(.subheadline).multilineTextAlignment(.leading)
                Text(points).font(.caption.bold()).padding(.horizontal, 8).padding(.vertical, 4).background(color.opacity(0.2)).clipShape(Capsule())
            }
            .frame(maxWidth: .infinity, minHeight: 88, alignment: .leading).padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        }.buttonStyle(.plain)
    }
}
