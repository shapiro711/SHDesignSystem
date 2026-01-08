import SwiftUI

// MARK: - Card Style
public enum SHCardStyle: String, CaseIterable, Sendable {
    case elevated
    case outlined
    case filled
    case glass

    public var displayName: String {
        switch self {
        case .elevated: return "Elevated"
        case .outlined: return "Outlined"
        case .filled: return "Filled"
        case .glass: return "Glass"
        }
    }
}

// MARK: - SHCard
public struct SHCard<Content: View>: View {
    @Environment(\.shTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let style: SHCardStyle
    private let padding: CGFloat
    private let action: (() -> Void)?
    private let content: Content

    public init(
        style: SHCardStyle = .elevated,
        padding: CGFloat = SH.spacing.md,
        @ViewBuilder content: () -> Content,
        action: (() -> Void)? = nil
    ) {
        self.style = style
        self.padding = padding
        self.action = action
        self.content = content()
    }

    public var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    cardContent
                }
                .buttonStyle(.plain)
            } else {
                cardContent
            }
        }
    }

    private var cardContent: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: SH.radius.xxl, style: .continuous))
            .overlay(overlayView)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .elevated, .outlined:
            SH.colors.surface
        case .filled:
            theme.primaryColor.opacity(0.08)
        case .glass:
            RoundedRectangle(cornerRadius: SH.radius.xxl, style: .continuous)
                .fill(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        switch style {
        case .elevated:
            EmptyView()
        case .outlined:
            RoundedRectangle(cornerRadius: SH.radius.xxl, style: .continuous)
                .stroke(SH.colors.border, lineWidth: 1)
        case .filled:
            EmptyView()
        case .glass:
            RoundedRectangle(cornerRadius: SH.radius.xxl, style: .continuous)
                .stroke(SH.colors.glassBorder, lineWidth: 1)
        }
    }

    private var shadowColor: Color {
        switch style {
        case .elevated:
            return colorScheme == .dark
                ? Color.black.opacity(0.3)
                : Color.black.opacity(0.08)
        default:
            return .clear
        }
    }

    private var shadowRadius: CGFloat {
        style == .elevated ? 16 : 0
    }

    private var shadowY: CGFloat {
        style == .elevated ? 4 : 0
    }
}

// MARK: - Image Card
public struct SHImageCard<Content: View>: View {
    @Environment(\.shTheme) private var theme

    private let image: Image
    private let imageHeight: CGFloat
    private let style: SHCardStyle
    private let action: (() -> Void)?
    private let content: Content

    public init(
        image: Image,
        imageHeight: CGFloat = 160,
        style: SHCardStyle = .elevated,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.image = image
        self.imageHeight = imageHeight
        self.style = style
        self.action = action
        self.content = content()
    }

    public var body: some View {
        SHCard(style: style, padding: 0, content: {
            VStack(spacing: 0) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: imageHeight)
                    .clipped()

                content
                    .padding(SH.spacing.md)
            }
        }, action: action)
    }
}

// MARK: - Action Card
public struct SHActionCard: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let style: SHCardStyle
    private let action: () -> Void

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        style: SHCardStyle = .glass,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.style = style
        self.action = action
    }

    public var body: some View {
        SHCard(style: style, content: {
            HStack(spacing: SH.spacing.md) {
                if let icon = icon {
                    SHCircledIcon(icon, size: .lg, style: .filled)
                }

                VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                    Text(title)
                        .font(SH.typography.titleMedium)
                        .foregroundStyle(SH.colors.textPrimary)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(SH.typography.bodySmall)
                            .foregroundStyle(SH.colors.textSecondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(SH.colors.textTertiary)
            }
        }, action: action)
    }
}

// MARK: - Stats Card
public struct SHStatsCard: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let value: String
    private let trend: Trend?
    private let icon: String?
    private let style: SHCardStyle

    public enum Trend {
        case up(String)
        case down(String)
        case neutral(String)

        var color: Color {
            switch self {
            case .up: return SH.colors.success
            case .down: return SH.colors.error
            case .neutral: return SH.colors.textSecondary
            }
        }

        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "arrow.right"
            }
        }

        var text: String {
            switch self {
            case .up(let value), .down(let value), .neutral(let value):
                return value
            }
        }
    }

    public init(
        title: String,
        value: String,
        trend: Trend? = nil,
        icon: String? = nil,
        style: SHCardStyle = .glass
    ) {
        self.title = title
        self.value = value
        self.trend = trend
        self.icon = icon
        self.style = style
    }

    public var body: some View {
        SHCard(style: style) {
            VStack(alignment: .leading, spacing: SH.spacing.sm) {
                HStack {
                    Text(title)
                        .font(SH.typography.labelMedium)
                        .foregroundStyle(SH.colors.textSecondary)

                    Spacer()

                    if let icon = icon {
                        SHIcon(icon, size: .md, color: theme.primaryColor)
                    }
                }

                Text(value)
                    .font(SH.typography.displaySmall)
                    .foregroundStyle(SH.colors.textPrimary)

                if let trend = trend {
                    HStack(spacing: SH.spacing.xxs) {
                        Image(systemName: trend.icon)
                            .font(.system(size: 12, weight: .medium))
                        Text(trend.text)
                            .font(SH.typography.caption)
                    }
                    .foregroundStyle(trend.color)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview("SHCard Styles") {
    ScrollView {
        VStack(spacing: 20) {
            ForEach(SHCardStyle.allCases, id: \.self) { style in
                SHCard(style: style) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(style.displayName)
                            .font(SH.typography.titleMedium)
                        Text("카드 내용이 들어갑니다.")
                            .font(SH.typography.bodyMedium)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
    }
    .shTheme(.pastelLavender)
}

#Preview("SHActionCard") {
    VStack(spacing: 16) {
        SHActionCard(title: "프로필 설정", subtitle: "이름과 사진을 변경해보세요", icon: "person.fill") {}
        SHActionCard(title: "알림 설정", icon: "bell.fill", style: .outlined) {}
    }
    .padding()
    .shTheme(.pastelPink)
}

#Preview("SHStatsCard") {
    VStack(spacing: 16) {
        SHStatsCard(title: "총 수익", value: "₩1,234,567", trend: .up("+12.5%"), icon: "chart.line.uptrend.xyaxis")
        SHStatsCard(title: "방문자", value: "8,234", trend: .down("-3.2%"), icon: "person.2.fill")
    }
    .padding()
    .shTheme(.pastelMint)
}
