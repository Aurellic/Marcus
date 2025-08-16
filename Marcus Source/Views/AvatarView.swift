import SwiftUI

/// Flexible avatar view that works with several common initializers.
/// Examples:
///   AvatarView()                                   // default placeholder
///   AvatarView(size: 40)                           // placeholder with size
///   AvatarView("JD", size: 40)                     // initials
///   AvatarView(imageName: "UserPhoto", size: 40)   // asset image
///   AvatarView(user: someUser, size: 40)           // shim for callers that pass `user:`
struct AvatarView: View {
    // Stored values
    private let image: Image?
    private let initials: String?
    private let size: CGFloat

    // MARK: - Designated initializer
    init(imageName: String? = nil, initials: String? = nil, size: CGFloat = 32) {
        if let name = imageName, !name.isEmpty {
            self.image = Image(name)
        } else {
            self.image = nil
        }
        self.initials = initials
        self.size = size
    }

    // Convenience: AvatarView("JD", size: 40)
    init(_ initials: String, size: CGFloat = 32) {
        self.init(imageName: nil, initials: initials, size: size)
    }

    // Convenience: AvatarView(size: 40) or AvatarView()
    init(size: CGFloat = 32) {
        self.init(imageName: nil, initials: nil, size: size)
    }

    // MARK: - Shim: accept `user:` from existing call sites
    // We don't know your User type, so we try to extract `imageName` or initials via reflection.
    init(user: Any?, size: CGFloat = 32) {
        var extractedImageName: String?
        var extractedInitials: String?

        if let u = user {
            let mirror = Mirror(reflecting: u)

            // Try common property names for an image asset
            let possibleImageKeys = ["imageName", "avatarImageName", "avatar", "photoName"]
            for child in mirror.children {
                if let label = child.label,
                   possibleImageKeys.contains(label),
                   let name = child.value as? String,
                   !name.isEmpty {
                    extractedImageName = name
                    break
                }
            }

            // If no image, try to build initials from name-like fields
            if extractedImageName == nil {
                var nameParts: [String] = []

                // common keys for first/last/display name
                let possibleNameKeys = ["initials", "name", "displayName", "fullName", "firstName", "lastName"]
                var foundInitialsDirectly: String?

                for child in mirror.children {
                    guard let label = child.label else { continue }
                    if label == "initials", let val = child.value as? String, !val.isEmpty {
                        foundInitialsDirectly = val
                        break
                    }
                    if let val = child.value as? String, possibleNameKeys.contains(label), !val.isEmpty {
                        nameParts.append(val)
                    }
                }

                if let direct = foundInitialsDirectly {
                    extractedInitials = direct
                } else if !nameParts.isEmpty {
                    extractedInitials = AvatarView.makeInitials(from: nameParts.joined(separator: " "))
                }
            }
        }

        self.init(imageName: extractedImageName, initials: extractedInitials, size: size)
    }

    // MARK: - View
    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else if let initials = initials, !initials.isEmpty {
                ZStack {
                    Circle().fill(Color("Blue").opacity(0.2))
                    Text(initials)
                        .font(.system(size: max(12, size * 0.42), weight: .semibold))
                        .foregroundColor(.primary)
                }
            } else {
                Circle().fill(Color.gray.opacity(0.2))
                Image(systemName: "person.fill")
                    .font(.system(size: max(12, size * 0.5)))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.black.opacity(0.06), lineWidth: 1))
        .accessibilityHidden(true)
    }

    // MARK: - Helpers
    private static func makeInitials(from name: String) -> String {
        let parts = name
            .split(whereSeparator: { !$0.isLetter })
            .map { String($0) }
            .filter { !$0.isEmpty }
        let first = parts.first?.first.map { String($0) } ?? ""
        let last = parts.dropFirst().last?.first.map { String($0) } ?? ""
        let initials = (first + last).uppercased()
        return initials.isEmpty ? "?" : initials
    }
}
