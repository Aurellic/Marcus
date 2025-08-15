import Foundation

final class QuoteService: ObservableObject {
    static let shared = QuoteService(); private init() {}
    @Published var all: [Quote] = []
    func loadFromBundle() {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json") else { return }
        do { let data = try Data(contentsOf: url); let decoded = try JSONDecoder().decode([Quote].self, from: data); self.all = decoded }
        catch { print("QuoteService error:", error); self.all = Quote.sample }
    }
    func todaysQuote() -> Quote? {
        if all.isEmpty { loadFromBundle() }
        guard !all.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let idx = day % all.count
        return all[idx]
    }
}
