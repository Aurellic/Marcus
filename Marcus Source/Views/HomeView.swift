import SwiftUI

struct HomeView: View {
    @EnvironmentObject var app: AppState
    @State private var showCreate = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    QuoteCard()
                    Text("Your Challenges").font(.title3.bold()).padding(.horizontal)
                    ForEach(app.challenges) { c in
                        NavigationLink(value: c) { ChallengeCard(challenge: c, progress: progress(for: c)) }.buttonStyle(.plain)
                    }
                }.padding(.vertical)
            }
            .navigationDestination(for: Challenge.self) { c in ChallengeDetailView(challenge: c) }
            .navigationTitle("Marcus")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button { showCreate = true } label: { Image(systemName: "plus.circle.fill").font(.title2) } } }
            .sheet(isPresented: $showCreate) { CreateChallengeWizard().presentationDetents([.medium, .large]) }
        }
    }
    func progress(for c: Challenge) -> Double {
        guard let end = c.endAt else { return 0.3 }
        let interval = end.timeIntervalSince(c.startAt)
        let sofar = Date().timeIntervalSince(c.startAt)
        return max(0, min(1, sofar / max(interval, 1)))
    }
}

struct QuoteCard: View {
    var quote = QuoteService.shared.todaysQuote()
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let q = quote {
                Text("“\(q.text)”").font(.body)
                Text(q.author).foregroundColor(.secondary).font(.footnote)
            } else { Text("No quote available").foregroundColor(.secondary) }
            HStack { Spacer(); NavigationLink { QuotesArchiveView() } label: { Text("Reflect").padding(.horizontal, 14).padding(.vertical, 8).background(Color.accentColor.opacity(0.2)).clipShape(Capsule()) } }
        }
        .padding().background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground))).padding(.horizontal)
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    let progress: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(challenge.name).font(.headline)
                    Text("\(challenge.members.count) members • \(endString())").foregroundColor(.secondary).font(.footnote)
                }
                Spacer()
                Image(systemName: "trophy.fill").foregroundColor(.yellow)
            }
            ProgressView(value: progress)
        }
        .padding().background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground))).padding(.horizontal)
    }
    func endString() -> String {
        if let end = challenge.endAt {
            let days = Calendar.current.dateComponents([.day], from: Date(), to: end).day ?? 0
            return days >= 0 ? "ends in \(days) days" : "ended \(-days) days ago"
        }
        return "open‑ended"
    }
}
