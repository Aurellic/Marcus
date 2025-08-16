import SwiftUI

struct LogHistoryView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // match Home background

            ScrollView {
                VStack(spacing: 16) {
                    MarcusHeaderCard(mood: .empathetic, title: "How has the day been?")
                    // EXAMPLE CARD 1 — replace with your real content later
                    BlueCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recent Reflections")
                                .font(.headline)
                            Text("You logged 3 entries this week.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // EXAMPLE CARD 2 — replace with your real content later
                    BlueCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Today • Reflection")
                                .font(.headline)
                            Text("Noted what I can control and let the rest go.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("History")
    }
}
