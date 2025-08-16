import SwiftUI
import Foundation

// Minimal, local model used by the launch screen
struct StoicQuote: Identifiable {
    var id: String { "\(attribution.prefix(10))-\(text.prefix(20))" }
    let text: String
    let attribution: String
    let source: String
    let publicDomain: Bool
}

// Reusable bottom hint pinned to the safe area (identical position on all screens)
private struct SkipHint: View {
    let color: Color
    var body: some View {
        Text("Tap to skip")
            .font(.footnote)
            .foregroundColor(color.opacity(0.6))
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity) // centers text
            .background(Color.clear)
    }
}

// Opening flow: logo → quote → done
struct LaunchFlowView: View {
    enum Phase { case logo, quote, done }
    @State private var phase: Phase = .logo

    let quote: StoicQuote
    let onFinish: () -> Void

    private let logoAutoAdvance: Double = 2.0  // seconds
    private let quoteAutoAdvance: Double = 2.0 // seconds

    var body: some View {
        ZStack {
            switch phase {
            case .logo:
                LogoScreen()
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                    .onAppear { scheduleAdvance(to: .quote, after: logoAutoAdvance) }
                    .contentShape(Rectangle())
                    .onTapGesture { go(.quote, animated: true) }   // tap once → quote

            case .quote:
                QuoteScreen(quote: quote)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                    .onAppear { scheduleAdvance(to: .done, after: quoteAutoAdvance) }
                    .contentShape(Rectangle())
                    .onTapGesture { go(.done, animated: true) }    // tap again → home

            case .done:
                Color.clear
                    .task { onFinish() } // notify parent to reveal Home
            }
        }
        // bind cross-fade to phase changes
        .animation(.easeInOut(duration: 0.5), value: phase)
        .accessibilityAddTraits(.isButton)
    }

    private func scheduleAdvance(to next: Phase, after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard phase != .done else { return }
            go(next, animated: true)
        }
    }

    private func go(_ next: Phase, animated: Bool) {
        withAnimation(animated ? .easeInOut(duration: 0.5) : nil) {
            phase = next
        }
    }
}

// MARK: - Subviews

private struct LogoScreen: View {
    @State private var showHint = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            Image("MarcusMonochrome")          // <-- exact asset name
                .resizable()
                .renderingMode(.original)
                .interpolation(.high)
                .antialiased(true)
                .scaledToFit()
                .frame(width: 200, height: 200)
                .accessibilityLabel("Marcus App")
        }
        // Pin the hint to the exact same place as QuoteScreen
        .safeAreaInset(edge: .bottom) {
            SkipHint(color: .black)
                .opacity(showHint ? 1 : 0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.35).delay(0.10)) {
                        showHint = true
                    }
                }
        }
        .contentShape(Rectangle())
    }
}

private struct QuoteScreen: View {
    let quote: StoicQuote
    @State private var showText = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 16) {
                Text("“\(quote.text)”")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Text("— \(quote.attribution)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .opacity(showText ? 1 : 0) // delayed fade-in for polish
            .onAppear {
                withAnimation(.easeInOut(duration: 0.35).delay(0.10)) {
                    showText = true
                }
            }
        }
        // Same bottom position as LogoScreen
        .safeAreaInset(edge: .bottom) {
            SkipHint(color: .gray)
        }
        .contentShape(Rectangle())
    }
}
