import SwiftUI

struct RootView: View {
    @EnvironmentObject var app: AppState
    @State private var selectedTab: Int = 0
    
    // Show/hide the launch sequence
    @State private var showLaunch = true
    
    // Temporary quote for the launch screen (we can wire this to your QuoteService next)
    private let launchQuote = StoicQuote(
        text: "Waste no more time arguing what a good man should be. Be one.",
        attribution: "Marcus Aurelius, Meditations (tr. George Long)",
        source: "Meditations",
        publicDomain: true
    )
    
    var body: some View {
        ZStack {
            // Background + your existing tabs
            Color("BG").ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house.fill") }
                    .tag(0)
                
                LogHistoryView()
                    .tabItem { Label("History", systemImage: "clock.fill") }
                    .tag(1)
                
                QuotesArchiveView()
                    .tabItem { Label("Quotes", systemImage: "quote.bubble.fill") }
                    .tag(2)
                
                ProfileSettingsView()
                    .tabItem { Label("Profile", systemImage: "person.fill") }
                    .tag(3)
            }
            .onAppear { QuoteService.shared.loadFromBundle() }
            .opacity(showLaunch ? 0 : 1) // hide tabs until launch finishes
            
            // Launch flow layered on top
            if showLaunch {
                LaunchFlowView(
                    quote: launchQuote,
                    onFinish: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showLaunch = false
                        }
                    }
                )
                .transition(.opacity)
            }
        }
        .tint(Color("BrandBlue")) // keep your accent color
    }
}
