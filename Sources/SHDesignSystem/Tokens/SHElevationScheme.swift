import SwiftUI

// MARK: - Shadow Token

public struct SHShadowToken: Sendable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat = 0, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    public static let none = SHShadowToken(color: .clear, radius: 0, y: 0)
}

// MARK: - Elevation Scheme
/// 그림자를 레벨로 고정한다. 컴포넌트가 radius/opacity를 직접 고르면
/// 화면마다 깊이감이 어긋나기 때문에 조합을 여기서만 정의한다.
public struct SHElevationScheme: Sendable {
    /// 평면. 배경과 같은 층.
    public let flat: SHShadowToken
    /// 리스트 카드, 칩처럼 살짝 떠 있는 요소.
    public let raised: SHShadowToken
    /// 주요 카드, 팝오버.
    public let floating: SHShadowToken
    /// 시트, 다이얼로그.
    public let overlay: SHShadowToken

    public init(
        flat: SHShadowToken,
        raised: SHShadowToken,
        floating: SHShadowToken,
        overlay: SHShadowToken
    ) {
        self.flat = flat
        self.raised = raised
        self.floating = floating
        self.overlay = overlay
    }

    /// 시그니처: 넓고 옅은 그림자. 파스텔 위에서 딱딱해 보이지 않게 한다.
    static func signature(shadow: Color) -> SHElevationScheme {
        SHElevationScheme(
            flat: .none,
            raised: SHShadowToken(color: shadow, radius: 10, y: 3),
            floating: SHShadowToken(color: shadow, radius: 20, y: 8),
            overlay: SHShadowToken(color: shadow, radius: 32, y: 14)
        )
    }
}

// MARK: - Application

public extension View {
    func shShadow(_ token: SHShadowToken) -> some View {
        shadow(color: token.color, radius: token.radius, x: token.x, y: token.y)
    }

    /// 예: `.shElevation(\.floating)`
    func shElevation(_ keyPath: KeyPath<SHElevationScheme, SHShadowToken>) -> some View {
        modifier(SHElevationModifier(keyPath: keyPath))
    }
}

struct SHElevationModifier: ViewModifier {
    @Environment(\.shTheme) private var theme
    let keyPath: KeyPath<SHElevationScheme, SHShadowToken>

    func body(content: Content) -> some View {
        content.shShadow(theme.elevation[keyPath: keyPath])
    }
}
