import SwiftUI

// MARK: - Font Token
/// 폰트를 `Font`로 굳혀두지 않고 토큰으로 들고 있는 이유는 Dynamic Type 때문이다.
/// `Font.system(size:)`는 사용자 글자 크기 설정에 반응하지 않으므로,
/// 렌더 시점에 `@ScaledMetric`으로 스케일해서 적용한다.
public struct SHFontToken: Sendable, Equatable {
    /// 기본 크기(Large 기준).
    public let size: CGFloat
    public let weight: Font.Weight
    /// 스케일 기준이 되는 시스템 텍스트 스타일.
    public let relativeTo: Font.TextStyle
    /// 행간 배수. 한글 가독성 때문에 본문은 1.5 근처를 쓴다.
    public let lineHeight: CGFloat
    public let tracking: CGFloat

    public init(
        size: CGFloat,
        weight: Font.Weight,
        relativeTo: Font.TextStyle,
        lineHeight: CGFloat = 1.4,
        tracking: CGFloat = 0
    ) {
        self.size = size
        self.weight = weight
        self.relativeTo = relativeTo
        self.lineHeight = lineHeight
        self.tracking = tracking
    }
}

// MARK: - Typography Scheme

public struct SHTypographyScheme: Sendable {
    /// 시그니처 서체 형태. 기본값 `.rounded`가 SH의 정체성이다.
    public let design: Font.Design

    public let displayLarge: SHFontToken
    public let displayMedium: SHFontToken
    public let displaySmall: SHFontToken

    public let headlineLarge: SHFontToken
    public let headlineMedium: SHFontToken
    public let headlineSmall: SHFontToken

    public let titleLarge: SHFontToken
    public let titleMedium: SHFontToken
    public let titleSmall: SHFontToken

    public let bodyLarge: SHFontToken
    public let bodyMedium: SHFontToken
    public let bodySmall: SHFontToken

    public let labelLarge: SHFontToken
    public let labelMedium: SHFontToken
    public let labelSmall: SHFontToken

    public let caption: SHFontToken
    public let captionSmall: SHFontToken

    /// SH 시그니처 타이포 스케일.
    public static let signature = SHTypographyScheme(
        design: .rounded,

        displayLarge:  .init(size: 44, weight: .bold,      relativeTo: .largeTitle,  lineHeight: 1.15, tracking: -0.6),
        displayMedium: .init(size: 36, weight: .bold,      relativeTo: .largeTitle,  lineHeight: 1.18, tracking: -0.5),
        displaySmall:  .init(size: 30, weight: .bold,      relativeTo: .largeTitle,  lineHeight: 1.20, tracking: -0.4),

        headlineLarge:  .init(size: 28, weight: .semibold, relativeTo: .title,       lineHeight: 1.25, tracking: -0.3),
        headlineMedium: .init(size: 24, weight: .semibold, relativeTo: .title,       lineHeight: 1.28, tracking: -0.2),
        headlineSmall:  .init(size: 22, weight: .semibold, relativeTo: .title2,      lineHeight: 1.30, tracking: -0.2),

        titleLarge:  .init(size: 20, weight: .semibold,    relativeTo: .title3,      lineHeight: 1.35),
        titleMedium: .init(size: 18, weight: .semibold,    relativeTo: .headline,    lineHeight: 1.38),
        titleSmall:  .init(size: 16, weight: .medium,      relativeTo: .headline,    lineHeight: 1.40),

        bodyLarge:  .init(size: 17, weight: .regular,      relativeTo: .body,        lineHeight: 1.52),
        bodyMedium: .init(size: 15, weight: .regular,      relativeTo: .body,        lineHeight: 1.50),
        bodySmall:  .init(size: 13, weight: .regular,      relativeTo: .footnote,    lineHeight: 1.46),

        labelLarge:  .init(size: 15, weight: .medium,      relativeTo: .subheadline, lineHeight: 1.30),
        labelMedium: .init(size: 13, weight: .medium,      relativeTo: .footnote,    lineHeight: 1.30),
        labelSmall:  .init(size: 11, weight: .medium,      relativeTo: .caption2,    lineHeight: 1.28),

        caption:      .init(size: 12, weight: .regular,    relativeTo: .caption,     lineHeight: 1.34),
        captionSmall: .init(size: 10, weight: .regular,    relativeTo: .caption2,    lineHeight: 1.30)
    )
}

// MARK: - Application

/// 토큰 하나를 Dynamic Type에 맞춰 적용한다.
/// `@ScaledMetric`이 사용자 글자 크기 변경을 실시간으로 반영한다.
struct SHFontModifier: ViewModifier {
    @ScaledMetric private var scaledSize: CGFloat

    private let token: SHFontToken
    private let design: Font.Design

    init(token: SHFontToken, design: Font.Design) {
        self.token = token
        self.design = design
        self._scaledSize = ScaledMetric(wrappedValue: token.size, relativeTo: token.relativeTo)
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: scaledSize, weight: token.weight, design: design))
            .tracking(token.tracking)
            .lineSpacing(scaledSize * (token.lineHeight - 1))
    }
}

/// 테마에서 토큰을 꺼내 적용하는 진입점.
struct SHThemedFontModifier: ViewModifier {
    @Environment(\.shTheme) private var theme
    let keyPath: KeyPath<SHTypographyScheme, SHFontToken>

    func body(content: Content) -> some View {
        content.modifier(
            SHFontModifier(
                token: theme.typography[keyPath: keyPath],
                design: theme.typography.design
            )
        )
    }
}

public extension View {
    /// 예: `.shFont(\.titleMedium)`
    func shFont(_ keyPath: KeyPath<SHTypographyScheme, SHFontToken>) -> some View {
        modifier(SHThemedFontModifier(keyPath: keyPath))
    }

    /// 토큰을 직접 들고 있을 때.
    func shFont(_ token: SHFontToken, design: Font.Design = .rounded) -> some View {
        modifier(SHFontModifier(token: token, design: design))
    }
}
