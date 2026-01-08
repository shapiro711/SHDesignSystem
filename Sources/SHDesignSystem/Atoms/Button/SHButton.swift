import SwiftUI

// MARK: - Button Style
public enum SHButtonStyle: String, CaseIterable, Sendable {
    case primary
    case secondary
    case outlined
    case ghost
    case destructive
    case glass

    public var displayName: String {
        switch self {
        case .primary: return "Primary"
        case .secondary: return "Secondary"
        case .outlined: return "Outlined"
        case .ghost: return "Ghost"
        case .destructive: return "Destructive"
        case .glass: return "Glass"
        }
    }
}

// MARK: - Button Size
public enum SHButtonSize: String, CaseIterable, Sendable {
    case small
    case medium
    case large

    var height: CGFloat {
        switch self {
        case .small: return 36
        case .medium: return 48
        case .large: return 56
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return SH.spacing.sm
        case .medium: return SH.spacing.lg
        case .large: return SH.spacing.xl
        }
    }

    var font: Font {
        switch self {
        case .small: return SH.typography.labelMedium
        case .medium: return SH.typography.labelLarge
        case .large: return SH.typography.titleSmall
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 24
        }
    }
}

// MARK: - SHButton
public struct SHButton: View {
    @Environment(\.shTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    private let title: String
    private let icon: String?
    private let style: SHButtonStyle
    private let size: SHButtonSize
    private let isLoading: Bool
    private let isFullWidth: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        icon: String? = nil,
        style: SHButtonStyle = .primary,
        size: SHButtonSize = .medium,
        isLoading: Bool = false,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: SH.spacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: size.iconSize, weight: .medium))
                    }
                    Text(title)
                        .font(size.font)
                }
            }
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
            .foregroundStyle(foregroundColor)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous))
            .overlay(overlayView)
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1.0 : 0.5)
        .allowsHitTesting(!isLoading && isEnabled)
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return SH.colors.textOnColor
        case .secondary, .outlined:
            return theme.primaryColor
        case .ghost:
            return theme.primaryColor
        case .destructive:
            return .white
        case .glass:
            return SH.colors.textPrimary
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            theme.primaryColor
        case .secondary:
            theme.primaryColor.opacity(0.15)
        case .outlined, .ghost:
            Color.clear
        case .destructive:
            SH.colors.error
        case .glass:
            glassBackground
        }
    }

    @ViewBuilder
    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
            .fill(.ultraThinMaterial)
    }

    @ViewBuilder
    private var overlayView: some View {
        switch style {
        case .outlined, .ghost:
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .stroke(theme.primaryColor, lineWidth: 1.5)
        case .glass:
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .stroke(SH.colors.glassBorder, lineWidth: 1)
        default:
            EmptyView()
        }
    }
}

// MARK: - Icon Only Button
public struct SHIconButton: View {
    @Environment(\.shTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    private let icon: String
    private let style: SHButtonStyle
    private let size: SHButtonSize
    private let action: () -> Void

    public init(
        icon: String,
        style: SHButtonStyle = .ghost,
        size: SHButtonSize = .medium,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.style = style
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .medium))
                .frame(width: size.height, height: size.height)
                .foregroundStyle(foregroundColor)
                .background(backgroundView)
                .clipShape(Circle())
                .overlay(
                    Group {
                        if style == .outlined || style == .ghost {
                            Circle()
                                .stroke(theme.primaryColor, lineWidth: 1.5)
                        } else if style == .glass {
                            Circle()
                                .stroke(SH.colors.glassBorder, lineWidth: 1)
                        }
                    }
                )
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1.0 : 0.5)
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return SH.colors.textOnColor
        case .secondary, .outlined, .ghost:
            return theme.primaryColor
        case .destructive:
            return .white
        case .glass:
            return SH.colors.textPrimary
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            theme.primaryColor
        case .secondary:
            theme.primaryColor.opacity(0.15)
        case .outlined, .ghost:
            Color.clear
        case .destructive:
            SH.colors.error
        case .glass:
            Circle().fill(.ultraThinMaterial)
        }
    }
}

// MARK: - Preview
#Preview("SHButton Styles") {
    VStack(spacing: 20) {
        ForEach(SHButtonStyle.allCases, id: \.self) { style in
            SHButton("버튼", icon: "star.fill", style: style) {}
        }
    }
    .padding()
    .shTheme(.pastelLavender)
}

#Preview("SHButton Sizes") {
    VStack(spacing: 20) {
        ForEach(SHButtonSize.allCases, id: \.self) { size in
            SHButton("버튼", size: size) {}
        }
    }
    .padding()
    .shTheme(.pastelMint)
}
