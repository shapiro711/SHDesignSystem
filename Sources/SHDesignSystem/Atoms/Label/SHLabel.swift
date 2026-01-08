import SwiftUI

// MARK: - Label Style
public enum SHLabelStyle: String, CaseIterable, Sendable {
    case display
    case headline
    case title
    case body
    case caption

    public var displayName: String {
        switch self {
        case .display: return "Display"
        case .headline: return "Headline"
        case .title: return "Title"
        case .body: return "Body"
        case .caption: return "Caption"
        }
    }
}

// MARK: - Label Color
public enum SHLabelColor: Sendable {
    case primary
    case secondary
    case tertiary
    case accent
    case custom(Color)
}

// MARK: - SHLabel
public struct SHLabel: View {
    @Environment(\.shTheme) private var theme

    private let text: String
    private let style: SHLabelStyle
    private let weight: Font.Weight?
    private let color: SHLabelColor
    private let alignment: TextAlignment

    public init(
        _ text: String,
        style: SHLabelStyle = .body,
        weight: Font.Weight? = nil,
        color: SHLabelColor = .primary,
        alignment: TextAlignment = .leading
    ) {
        self.text = text
        self.style = style
        self.weight = weight
        self.color = color
        self.alignment = alignment
    }

    public var body: some View {
        Text(text)
            .font(font)
            .fontWeight(weight)
            .foregroundStyle(foregroundColor)
            .multilineTextAlignment(alignment)
    }

    private var font: Font {
        switch style {
        case .display:
            return SH.typography.displayMedium
        case .headline:
            return SH.typography.headlineMedium
        case .title:
            return SH.typography.titleMedium
        case .body:
            return SH.typography.bodyMedium
        case .caption:
            return SH.typography.caption
        }
    }

    private var foregroundColor: Color {
        switch color {
        case .primary:
            return SH.colors.textPrimary
        case .secondary:
            return SH.colors.textSecondary
        case .tertiary:
            return SH.colors.textTertiary
        case .accent:
            return theme.primaryColor
        case .custom(let color):
            return color
        }
    }
}

// MARK: - Attributed Label (with icon)
public struct SHIconLabel: View {
    @Environment(\.shTheme) private var theme

    private let text: String
    private let icon: String
    private let iconPosition: IconPosition
    private let style: SHLabelStyle
    private let color: SHLabelColor
    private let spacing: CGFloat

    public enum IconPosition {
        case leading
        case trailing
    }

    public init(
        _ text: String,
        icon: String,
        iconPosition: IconPosition = .leading,
        style: SHLabelStyle = .body,
        color: SHLabelColor = .primary,
        spacing: CGFloat = SH.spacing.xs
    ) {
        self.text = text
        self.icon = icon
        self.iconPosition = iconPosition
        self.style = style
        self.color = color
        self.spacing = spacing
    }

    public var body: some View {
        HStack(spacing: spacing) {
            if iconPosition == .leading {
                iconView
            }

            SHLabel(text, style: style, color: color)

            if iconPosition == .trailing {
                iconView
            }
        }
    }

    private var iconView: some View {
        Image(systemName: icon)
            .font(iconFont)
            .foregroundStyle(iconColor)
    }

    private var iconFont: Font {
        switch style {
        case .display: return .system(size: 32, weight: .medium)
        case .headline: return .system(size: 24, weight: .medium)
        case .title: return .system(size: 18, weight: .medium)
        case .body: return .system(size: 15, weight: .medium)
        case .caption: return .system(size: 12, weight: .medium)
        }
    }

    private var iconColor: Color {
        switch color {
        case .primary:
            return SH.colors.textPrimary
        case .secondary:
            return SH.colors.textSecondary
        case .tertiary:
            return SH.colors.textTertiary
        case .accent:
            return theme.primaryColor
        case .custom(let color):
            return color
        }
    }
}

// MARK: - Preview
#Preview("SHLabel Styles") {
    VStack(alignment: .leading, spacing: 16) {
        ForEach(SHLabelStyle.allCases, id: \.self) { style in
            SHLabel("안녕하세요 \(style.displayName)", style: style)
        }
    }
    .padding()
}

#Preview("SHIconLabel") {
    VStack(alignment: .leading, spacing: 16) {
        SHIconLabel("별점", icon: "star.fill", color: .accent)
        SHIconLabel("설정", icon: "gear", style: .title)
        SHIconLabel("다음", icon: "chevron.right", iconPosition: .trailing)
    }
    .padding()
    .shTheme(.pastelPink)
}
