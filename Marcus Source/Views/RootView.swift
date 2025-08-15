import SwiftUI

struct RootView: View {
    @EnvironmentObject var app: AppState
    @State private var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tabItem { Label("Home", systemImage: "house.fill") }.tag(0)
            LogHistoryView().tabItem { Label("History", systemImage: "clock.fill") }.tag(1)
            QuotesArchiveView().tabItem { Label("Quotes", systemImage: "quote.bubble.fill") }.tag(2)
            ProfileSettingsView().tabItem { Label("Profile", systemImage: "person.fill") }.tag(3)
        }.onAppear { QuoteService.shared.loadFromBundle() }
    }
}
