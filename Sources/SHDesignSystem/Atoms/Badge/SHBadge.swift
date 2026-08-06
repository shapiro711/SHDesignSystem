import SwiftUI

// MARK: - SHBadge

public struct SHBadge: View {
    @Environment(\.shTheme) private var theme

    private let content: Content
    private let kind: SHStatusKind
    private let style: Style

    public enum Content {
        case count(Int, max: Int = 99)
        case text(String)
        /// 점만 찍는 알림 표시.
        case dot
    }

    public enum Style: Sendable {
        case filled
        case tinted
    }

    public init(_ content: Content, kind: SHStatusKind = .error, style: Style = .filled) {
        self.content = content
        self.kind = kind
        self.style = style
    }

    public static func count(_ value: Int) -> SHBadge {
        SHBadge(.count(value))
    }

    public var body: some View {
        Group {
            switch content {
            case .dot:
                Circle()
                    .fill(background)
                    .frame(width: SH.spacing.xs, height: SH.spacing.xs)
            case .count(let value, let max):
                label(value > max ? "\(max)+" : "\(value)")
            case .text(let text):
                label(text)
            }
        }
        .accessibilityLabel(Text(accessibilityLabel))
    }

    private func label(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .foregroundStyle(foreground)
            .padding(.horizontal, SH.spacing.xxs + 1)
            .frame(minWidth: 18, minHeight: 18)
            .background(background)
            .clipShape(Capsule(style: .continuous))
    }

    private var background: Color {
        style == .filled ? theme.colors.fill(for: kind) : theme.colors.container(for: kind)
    }

    private var foreground: Color {
        style == .filled ? theme.colors.onFill(for: kind) : theme.colors.onContainer(for: kind)
    }

    private var accessibilityLabel: String {
        switch content {
        case .dot: return "새 알림"
        case .count(let value, _): return "\(value)개"
        case .text(let text): return text
        }
    }
}

// MARK: - Badge Attachment

public extension View {
    /// 아이콘 우상단에 배지를 붙인다.
    func shBadge(_ badge: SHBadge?, alignment: Alignment = .topTrailing) -> some View {
        overlay(alignment: alignment) {
            if let badge {
                badge.alignmentGuide(.top) { $0[.bottom] / 2 }
                     .alignmentGuide(.trailing) { $0[.leading] + $0.width / 2 }
            }
        }
    }
}

// MARK: - SHTag

/// 상태 라벨. 칩과 달리 상호작용하지 않는다.
public struct SHTag: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let kind: SHStatusKind
    private let icon: String?

    public init(_ title: String, kind: SHStatusKind = .info, icon: String? = nil) {
        self.title = title
        self.kind = kind
        self.icon = icon
    }

    public var body: some View {
        HStack(spacing: SH.spacing.xxs) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: SH.size.iconXS, weight: .bold))
                    .accessibilityHidden(true)
            }
            SHText(title, \.labelSmall, role: .status(kind))
        }
        .foregroundStyle(theme.colors.onContainer(for: kind))
        .padding(.horizontal, SH.spacing.xs)
        .padding(.vertical, SH.spacing.xxs)
        .background(theme.colors.container(for: kind))
        .clipShape(Capsule(style: .continuous))
    }
}

// MARK: - Preview

#Preview("Badge & Tag") {
    VStack(spacing: SH.spacing.xl) {
        HStack(spacing: SH.spacing.xl) {
            SHIcon("bell.fill", size: .xl)
                .shBadge(.count(3))
            SHIcon("envelope.fill", size: .xl)
                .shBadge(.count(128))
            SHIcon("person.fill", size: .xl)
                .shBadge(SHBadge(.dot))
        }

        HStack(spacing: SH.spacing.xs) {
            SHTag("완료", kind: .success, icon: "checkmark")
            SHTag("진행중", kind: .info)
            SHTag("지연", kind: .warning)
            SHTag("실패", kind: .error)
        }
    }
    .padding()
    .background(SHThemeBackground())
    .shTheme(.lavender)
}
