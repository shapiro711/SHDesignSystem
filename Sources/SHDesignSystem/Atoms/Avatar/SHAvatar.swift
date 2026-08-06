import SwiftUI

// MARK: - SHAvatar

public struct SHAvatar: View {
    @Environment(\.shTheme) private var theme

    private let source: Source
    private let size: CGFloat
    private let accessibilityLabel: String?

    public enum Source {
        case image(Image)
        case url(URL?)
        /// 이름에서 이니셜을 만든다.
        case initials(String)
        case icon(String)
    }

    public init(_ source: Source, size: CGFloat = 44, accessibilityLabel: String? = nil) {
        self.source = source
        self.size = size
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        content
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(theme.colors.border, lineWidth: SH.size.border))
            .accessibilityLabel(Text(accessibilityLabel ?? ""))
            .accessibilityHidden(accessibilityLabel == nil)
    }

    @ViewBuilder
    private var content: some View {
        switch source {
        case .image(let image):
            image.resizable().aspectRatio(contentMode: .fill)

        case .url(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    placeholder(icon: "person.fill")
                case .empty:
                    theme.colors.surfaceSunken
                @unknown default:
                    placeholder(icon: "person.fill")
                }
            }

        case .initials(let name):
            ZStack {
                theme.colors.primaryContainer
                Text(Self.initials(from: name))
                    .font(.system(size: size * 0.38, weight: .semibold, design: .rounded))
                    .foregroundStyle(theme.colors.onPrimaryContainer)
            }

        case .icon(let systemName):
            placeholder(icon: systemName)
        }
    }

    private func placeholder(icon: String) -> some View {
        ZStack {
            theme.colors.primaryContainer
            Image(systemName: icon)
                .font(.system(size: size * 0.42, weight: .medium))
                .foregroundStyle(theme.colors.onPrimaryContainer)
        }
    }

    /// 한글은 이름 전체가 짧아 앞 두 글자, 로마자는 각 단어 첫 글자를 쓴다.
    static func initials(from name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "?" }

        let words = trimmed.split(separator: " ")
        if words.count >= 2 {
            return words.prefix(2).compactMap { $0.first }.map(String.init).joined().uppercased()
        }
        return String(trimmed.prefix(trimmed.first?.isLetter == true && trimmed.count > 2 ? 1 : 2)).uppercased()
    }
}

// MARK: - SHAvatarGroup

/// 겹쳐 놓은 아바타 묶음. 참여자 목록 등에 쓴다.
public struct SHAvatarGroup: View {
    @Environment(\.shTheme) private var theme

    private let avatars: [SHAvatar.Source]
    private let size: CGFloat
    private let maxVisible: Int

    public init(_ avatars: [SHAvatar.Source], size: CGFloat = 32, maxVisible: Int = 4) {
        self.avatars = avatars
        self.size = size
        self.maxVisible = maxVisible
    }

    public var body: some View {
        HStack(spacing: -size * 0.3) {
            ForEach(Array(avatars.prefix(maxVisible).enumerated()), id: \.offset) { _, source in
                SHAvatar(source, size: size)
                    .overlay(Circle().stroke(theme.colors.surface, lineWidth: 2))
            }

            if avatars.count > maxVisible {
                ZStack {
                    Circle().fill(theme.colors.surfaceSunken)
                    Text("+\(avatars.count - maxVisible)")
                        .font(.system(size: size * 0.34, weight: .semibold, design: .rounded))
                        .foregroundStyle(theme.colors.textSecondary)
                }
                .frame(width: size, height: size)
                .overlay(Circle().stroke(theme.colors.surface, lineWidth: 2))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(avatars.count)명"))
    }
}

// MARK: - Preview

#Preview("Avatar") {
    VStack(spacing: SH.spacing.lg) {
        HStack(spacing: SH.spacing.md) {
            SHAvatar(.initials("김도형"), size: 56)
            SHAvatar(.initials("Ada Lovelace"), size: 56)
            SHAvatar(.icon("person.fill"), size: 56)
        }
        SHAvatarGroup([
            .initials("김"), .initials("이"), .initials("박"),
            .initials("최"), .initials("정"), .initials("한")
        ])
    }
    .padding()
    .background(SHThemeBackground())
    .shTheme(.peach)
}
