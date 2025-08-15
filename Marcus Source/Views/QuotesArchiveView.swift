import SwiftUI

struct QuotesArchiveView: View {
    @State private var all = QuoteService.shared.all
    var body: some View {
        List {
            if let q = QuoteService.shared.todaysQuote() {
                Section("Today") {
                    VStack(alignment: .leading, spacing: 6) { Text("“\(q.text)”"); Text("— \(q.author)").foregroundColor(.secondary).font(.caption) }
                }
            }
            Section("Archive") {
                ForEach(all) { q in VStack(alignment: .leading, spacing: 6) { Text("“\(q.text)”"); Text("— \(q.author)").foregroundColor(.secondary).font(.caption) } }
            }
        }.navigationTitle("Quotes").onAppear { all = QuoteService.shared.all }.listStyle(.insetGrouped)
    }
}
