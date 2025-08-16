import SwiftUI

struct QuotesArchiveView: View {
    // TEMP demo data so you can see the style immediately.
    // Replace this with your real quotes model when ready.
    private let demoQuotes: [(text: String, attribution: String)] = [
        ("You have power over your mind — not outside events.", "Marcus Aurelius, Meditations"),
        ("Men are disturbed not by things, but by the views they take of things.", "Epictetus, Enchiridion"),
        ("It is not that we have a short time to live, but that we waste much of it.", "Seneca, On the Shortness of Life")
    ]

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // match other tabs

            ScrollView {
                VStack(spacing: 16) {
                    MarcusHeaderCard(mood: .reflective, title: "A thought worth sitting with.")
                    // Header card (optional)
                    BlueCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Saved Quotes")
                                .font(.headline)
                            Text("Your favorites and recent quotes.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Quote rows as blue cards
                    ForEach(Array(demoQuotes.enumerated()), id: \.offset) { _, q in
                        BlueCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("“\(q.text)”")
                                    .font(.body)
                                Text("— \(q.attribution)")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Quotes")
    }
}
