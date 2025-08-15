import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject var app: AppState
    @State private var dailyQuoteOn = true
    @State private var eveningNudgeOn = true
    @State private var shareLogsOn = true
    @State private var useHealthOn = false
    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    AvatarView(user: app.currentUser).frame(width: 42, height: 42)
                    VStack(alignment: .leading) { Text(app.currentUser.name).font(.headline); Text("Joined \(Date(), format: .dateTime.year().month())").font(.caption).foregroundColor(.secondary) }
                }
            }
            Section("Notifications") { Toggle("Daily Quote at 7am", isOn: $dailyQuoteOn); Toggle("Nudge if 0 points by 6pm", isOn: $eveningNudgeOn) }
            Section("Privacy & Data") { Toggle("Share logs with members", isOn: $shareLogsOn); Toggle("Use Apple Health (read-only)", isOn: $useHealthOn) }
        }.navigationTitle("Profile")
    }
}

struct AvatarView: View {
    let user: User
    var body: some View {
        ZStack { Circle().fill(user.avatarColor.color); Text(user.initials).bold().foregroundColor(.white) }
    }
}
