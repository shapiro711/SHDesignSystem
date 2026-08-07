import SwiftUI

// MARK: - Text Role

public enum SHTextRole: Sendable, Equatable {
    case primary
    case secondary
    case tertiary
    case disabled
    /// 표면 위 브랜드 색 강조.
    case brand
    case status(SHStatusKind)
    case custom(Color)
}

// MARK: - SHText

/// 타이포 토큰과 색 역할을 한 번에 적용하는 텍스트.
///
/// 스타일 인자는 `SHTypographyScheme`의 키패스라, 타이포 스케일에
/// 항목이 추가돼도 열거형을 따라 늘릴 필요가 없다.
///
/// 위젯처럼 폭이 고정된 자리에서 큰 숫자를 담아야 하면 `minimumScaleFactor`를 준다.
/// 이게 없으면 큰 타이포가 잘려서 결국 `Text` + `.shFont`로 내려가게 된다.
///
/// ```swift
/// SHText(countdown, \.displayLarge, lineLimit: 1, minimumScaleFactor: 0.6)
/// ```
public struct SHText: View {
    @Environment(\.shTheme) private var theme

    private let text: String
    private let style: KeyPath<SHTypographyScheme, SHFontToken>
    private let role: SHTextRole
    private let alignment: TextAlignment
    private let lineLimit: Int?
    private let minimumScaleFactor: CGFloat

    public init(
        _ text: String,
        _ style: KeyPath<SHTypographyScheme, SHFontToken> = \.bodyMedium,
        role: SHTextRole = .primary,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil,
        minimumScaleFactor: CGFloat = 1
    ) {
        self.text = text
        self.style = style
        self.role = role
        self.alignment = alignment
        self.lineLimit = lineLimit
        self.minimumScaleFactor = minimumScaleFactor
    }

    public var body: some View {
        Text(text)
            .shFont(style)
            .foregroundStyle(color)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
            .minimumScaleFactor(minimumScaleFactor)
    }

    private var color: Color {
        theme.colors.resolve(role)
    }
}

// MARK: - Role Resolution

public extension SHColorScheme {
    func resolve(_ role: SHTextRole) -> Color {
        switch role {
        case .primary:        return textPrimary
        case .secondary:      return textSecondary
        case .tertiary:       return textTertiary
        case .disabled:       return textDisabled
        case .brand:          return primaryText
        case .status(let k):  return onContainer(for: k)
        case .custom(let c):  return c
        }
    }
}

// MARK: - SHIconText

/// 아이콘 + 텍스트 조합. 아이콘은 장식이므로 VoiceOver에서 감춰지고
/// 텍스트만 읽힌다.
public struct SHIconText: View {
    @Environment(\.shTheme) private var theme

    private let text: String
    private let icon: String
    private let placement: Placement
    private let style: KeyPath<SHTypographyScheme, SHFontToken>
    private let role: SHTextRole
    private let spacing: CGFloat

    public enum Placement: Sendable { case leading, trailing }

    public init(
        _ text: String,
        icon: String,
        placement: Placement = .leading,
        style: KeyPath<SHTypographyScheme, SHFontToken> = \.bodyMedium,
        role: SHTextRole = .primary,
        spacing: CGFloat = SH.spacing.xs
    ) {
        self.text = text
        self.icon = icon
        self.placement = placement
        self.style = style
        self.role = role
        self.spacing = spacing
    }

    public var body: some View {
        HStack(spacing: spacing) {
            if placement == .leading { iconView }
            SHText(text, style, role: role)
            if placement == .trailing { iconView }
        }
    }

    private var iconView: some View {
        Image(systemName: icon)
            // 아이콘도 Dynamic Type을 따라가야 텍스트와 어긋나지 않는다.
            .font(.system(size: theme.typography[keyPath: style].size, weight: .medium))
            .foregroundStyle(theme.colors.resolve(role))
            .accessibilityHidden(true)
    }
}

// MARK: - Preview

#Preview("Typography Scale") {
    ScrollView {
        VStack(alignment: .leading, spacing: SH.spacing.sm) {
            Group {
                SHText("Display Large 몽글", \.displayLarge)
                SHText("Headline Medium 몽글", \.headlineMedium)
                SHText("Title Medium 몽글", \.titleMedium)
                SHText("Body Large — 한글 본문의 행간을 확인합니다. 두 줄 이상일 때 읽기 편해야 합니다.", \.bodyLarge)
                SHText("Label Medium", \.labelMedium, role: .secondary)
                SHText("Caption", \.caption, role: .tertiary)
            }
            .shFullWidth(alignment: .leading)
        }
        .padding()
    }
    .background(SHThemeBackground())
    .shTheme(.mint)
}
