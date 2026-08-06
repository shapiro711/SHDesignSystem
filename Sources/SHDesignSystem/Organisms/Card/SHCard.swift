import SwiftUI

// MARK: - SHCard

public struct SHCard<Content: View>: View {
    @Environment(\.shTheme) private var theme

    private let surface: SHSurfaceRole
    private let padding: CGFloat
    private let action: (() -> Void)?
    private let content: Content

    /// trailing closure가 `content`로 가도록 `action`을 앞에 둔다.
    public init(
        surface: SHSurfaceRole = .elevated,
        padding: CGFloat = SH.spacing.md,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.surface = surface
        self.padding = padding
        self.action = action
        self.content = content()
    }

    public var body: some View {
        if let action {
            Button(action: action) { card }
                .buttonStyle(.shPressable)
                .accessibilityElement(children: .combine)
        } else {
            card
        }
    }

    private var card: some View {
        content
            .padding(padding)
            .shFullWidth(alignment: .leading)
            .shSurface(surface, shape: theme.shape.card)
    }
}

// MARK: - SHImageCard

public struct SHImageCard<Content: View>: View {
    @Environment(\.shTheme) private var theme

    private let image: Image
    private let imageHeight: CGFloat
    private let surface: SHSurfaceRole
    private let action: (() -> Void)?
    private let content: Content

    public init(
        image: Image,
        imageHeight: CGFloat = 168,
        surface: SHSurfaceRole = .elevated,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.image = image
        self.imageHeight = imageHeight
        self.surface = surface
        self.action = action
        self.content = content()
    }

    public var body: some View {
        SHCard(surface: surface, padding: 0, action: action) {
            VStack(spacing: 0) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: imageHeight)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .accessibilityHidden(true)

                content
                    .padding(SH.spacing.md)
            }
        }
    }
}

// MARK: - SHActionCard

public struct SHActionCard: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let surface: SHSurfaceRole
    private let action: () -> Void

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        surface: SHSurfaceRole = .elevated,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.surface = surface
        self.action = action
    }

    public var body: some View {
        SHCard(surface: surface, action: action) {
            HStack(spacing: SH.spacing.md) {
                if let icon {
                    SHCircledIcon(icon, size: .lg, role: .tinted)
                }

                VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                    SHText(title, \.titleMedium)
                    if let subtitle {
                        SHText(subtitle, \.bodySmall, role: .secondary)
                    }
                }

                Spacer(minLength: SH.spacing.xs)

                Image(systemName: "chevron.right")
                    .font(.system(size: SH.size.iconSM, weight: .semibold))
                    .foregroundStyle(theme.colors.textTertiary)
                    .accessibilityHidden(true)
            }
        }
    }
}

// MARK: - SHStatCard

public struct SHStatCard: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let value: String
    private let trend: Trend?
    private let icon: String?
    private let surface: SHSurfaceRole

    public enum Trend: Sendable, Equatable {
        case up(String)
        case down(String)
        case flat(String)

        var kind: SHStatusKind {
            switch self {
            case .up: return .success
            case .down: return .error
            case .flat: return .info
            }
        }

        var symbol: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .flat: return "arrow.right"
            }
        }

        var text: String {
            switch self {
            case .up(let v), .down(let v), .flat(let v): return v
            }
        }

        var accessibilityPrefix: String {
            switch self {
            case .up: return "증가"
            case .down: return "감소"
            case .flat: return "변화 없음"
            }
        }
    }

    public init(
        title: String,
        value: String,
        trend: Trend? = nil,
        icon: String? = nil,
        surface: SHSurfaceRole = .elevated
    ) {
        self.title = title
        self.value = value
        self.trend = trend
        self.icon = icon
        self.surface = surface
    }

    public var body: some View {
        SHCard(surface: surface) {
            VStack(alignment: .leading, spacing: SH.spacing.xs) {
                HStack {
                    SHText(title, \.labelMedium, role: .secondary)
                    Spacer()
                    if let icon {
                        SHIcon(icon, size: .md, color: theme.colors.primaryText)
                    }
                }

                SHText(value, \.headlineMedium)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)

                if let trend {
                    HStack(spacing: SH.spacing.xxs) {
                        Image(systemName: trend.symbol)
                            .font(.system(size: SH.size.iconXS, weight: .bold))
                        SHText(trend.text, \.caption, role: .custom(theme.colors.fill(for: trend.kind)))
                    }
                    .foregroundStyle(theme.colors.fill(for: trend.kind))
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(accessibilityLabel))
    }

    private var accessibilityLabel: String {
        var parts = [title, value]
        if let trend { parts.append("\(trend.accessibilityPrefix) \(trend.text)") }
        return parts.joined(separator: ", ")
    }
}

// MARK: - Preview

#Preview("Cards") {
    ScrollView {
        VStack(spacing: SH.spacing.md) {
            SHCard(surface: .elevated) { SHText("Elevated", \.titleMedium) }
            SHCard(surface: .outlined) { SHText("Outlined", \.titleMedium) }
            SHCard(surface: .tinted) { SHText("Tinted", \.titleMedium) }
            SHCard(surface: .status(.warning)) { SHText("Status", \.titleMedium, role: .status(.warning)) }

            SHActionCard(title: "프로필 설정", subtitle: "이름과 사진을 변경해보세요", icon: "person.fill") {}

            HStack(spacing: SH.spacing.md) {
                SHStatCard(title: "총 수익", value: "₩1,234,567", trend: .up("12.5%"), icon: "wonsign.circle.fill")
                SHStatCard(title: "방문자", value: "8,234", trend: .down("3.2%"), icon: "person.2.fill")
            }
        }
        .padding()
    }
    .background(SHThemeBackground())
    .shTheme(.peach)
}
