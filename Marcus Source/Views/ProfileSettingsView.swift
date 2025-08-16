import SwiftUI

struct ProfileSettingsView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // match other tabs

            ScrollView {
                VStack(spacing: 16) {
                    MarcusHeaderCard(mood: .celebratory, title: "You’re building a habit.")
                    // PROFILE INFO
                    BlueCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your Profile")
                                .font(.headline)
                            Text("Name: Jane Doe")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Member since: August 2025")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // SETTINGS
                    BlueCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Settings")
                                .font(.headline)
                            Text("• Notifications: On")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("• Theme: Light")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // LOGOUT / ACTIONS
                    BlueCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Actions")
                                .font(.headline)
                            Button("Log Out") {
                                // log out action
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Profile")
    }
}
