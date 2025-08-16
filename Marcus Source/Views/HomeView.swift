import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // match History/Quotes background

            ScrollView {
                VStack(spacing: 16) {

                    // 👇 Marcus greeting card at the very top
                    MarcusHeaderCard(
                        mood: .encouraging,   // you can try .neutral, .thoughtful, etc.
                        title: "Welcome back!"
                    )

                    // CHALLENGES
                    BlueCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Challenges")
                                .font(.headline)
                            Text("• Today’s challenge: Focus on what you can control.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // DAILY FOCUS
                    BlueCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Daily Focus")
                                .font(.headline)
                            Text("Practice voluntary discomfort: skip one small convenience.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // QUICK ACTIONS
                    BlueCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quick Actions")
                                .font(.headline)
                            HStack(spacing: 12) {
                                Button("Log Reflection") { /* open log */ }
                                    .buttonStyle(.bordered)
                                Button("Read Quotes") { /* open quotes */ }
                                    .buttonStyle(.bordered)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Home")
    }
}
