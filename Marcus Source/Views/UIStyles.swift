import SwiftUI

/// Rounded blue card on a white background, like your Home screen sections.
struct BlueCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("BrandBlue").opacity(0.10))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

/// Optional convenience modifier if you want to wrap existing stacks quickly.
struct BlueCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("BrandBlue").opacity(0.10))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

extension View {
    func blueCard() -> some View { self.modifier(BlueCardStyle()) }
}

/// A blue card header that shows a Marcus image (context mood) with a short caption.
struct MarcusHeaderCard: View {
    let mood: MarcusMood
    let title: String
    var size: CGFloat = 96

    var body: some View {
        BlueCard {
            HStack(alignment: .center, spacing: 14) {
                MarcusMoodImage(mood: mood, size: size)
                    .frame(width: size, height: size)

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                    Text(hint(for: mood))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }
        }
    }

    private func hint(for mood: MarcusMood) -> String {
        switch mood {
        case .neutral:
            return "Welcome back."
        case .focused:
            return "One step, then the next."
        case .thinking:
            return "Gathering your thoughts…"
        default:
            return "You got this."
        }
    }
}
