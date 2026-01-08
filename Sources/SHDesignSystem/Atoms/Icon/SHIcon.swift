import SwiftUI

// MARK: - Icon Size
public enum SHIconSize: CGFloat, CaseIterable, Sendable {
    case xs = 12
    case sm = 16
    case md = 20
    case lg = 24
    case xl = 32
    case xxl = 48

    public var displayName: String {
        switch self {
        case .xs: return "XS (12)"
        case .sm: return "SM (16)"
        case .md: return "MD (20)"
        case .lg: return "LG (24)"
        case .xl: return "XL (32)"
        case .xxl: return "XXL (48)"
        }
    }
}

// MARK: - Icon Weight
public enum SHIconWeight: Sendable {
    case light
    case regular
    case medium
    case semibold
    case bold

    var fontWeight: Font.Weight {
        switch self {
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        }
    }
}

// MARK: - SHIcon
public struct SHIcon: View {
    @Environment(\.shTheme) private var theme

    private let name: String
    private let size: SHIconSize
    private let weight: SHIconWeight
    private let color: Color?

    public init(
        _ name: String,
        size: SHIconSize = .md,
        weight: SHIconWeight = .regular,
        color: Color? = nil
    ) {
        self.name = name
        self.size = size
        self.weight = weight
        self.color = color
    }

    public var body: some View {
        Image(systemName: name)
            .font(.system(size: size.rawValue, weight: weight.fontWeight))
            .foregroundStyle(color ?? SH.colors.textPrimary)
    }
}

// MARK: - Themed Icon
public struct SHThemedIcon: View {
    @Environment(\.shTheme) private var theme

    private let name: String
    private let size: SHIconSize
    private let weight: SHIconWeight
    private let useAccent: Bool

    public init(
        _ name: String,
        size: SHIconSize = .md,
        weight: SHIconWeight = .regular,
        useAccent: Bool = false
    ) {
        self.name = name
        self.size = size
        self.weight = weight
        self.useAccent = useAccent
    }

    public var body: some View {
        Image(systemName: name)
            .font(.system(size: size.rawValue, weight: weight.fontWeight))
            .foregroundStyle(useAccent ? theme.accentColor : theme.primaryColor)
    }
}

// MARK: - Circled Icon
public struct SHCircledIcon: View {
    @Environment(\.shTheme) private var theme

    private let name: String
    private let size: SHIconSize
    private let style: Style

    public enum Style {
        case filled
        case outlined
        case glass
    }

    public init(
        _ name: String,
        size: SHIconSize = .md,
        style: Style = .filled
    ) {
        self.name = name
        self.size = size
        self.style = style
    }

    private var containerSize: CGFloat {
        size.rawValue * 2
    }

    public var body: some View {
        ZStack {
            backgroundView
            Image(systemName: name)
                .font(.system(size: size.rawValue, weight: .medium))
                .foregroundStyle(foregroundColor)
        }
        .frame(width: containerSize, height: containerSize)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .filled:
            Circle()
                .fill(theme.primaryColor)
        case .outlined:
            Circle()
                .stroke(theme.primaryColor, lineWidth: 1.5)
        case .glass:
            Circle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Circle()
                        .stroke(SH.colors.glassBorder, lineWidth: 1)
                )
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .filled:
            return SH.colors.textOnColor
        case .outlined:
            return theme.primaryColor
        case .glass:
            return SH.colors.textPrimary
        }
    }
}

// MARK: - Preview
#Preview("SHIcon Sizes") {
    HStack(spacing: 20) {
        ForEach(SHIconSize.allCases, id: \.self) { size in
            VStack {
                SHIcon("star.fill", size: size)
                Text(size.displayName)
                    .font(.caption2)
            }
        }
    }
    .padding()
}

#Preview("SHCircledIcon") {
    HStack(spacing: 20) {
        SHCircledIcon("star.fill", style: .filled)
        SHCircledIcon("star.fill", style: .outlined)
        SHCircledIcon("star.fill", style: .glass)
    }
    .padding()
    .shTheme(.pastelPink)
}
