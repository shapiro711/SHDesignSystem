import SwiftUI

// MARK: - Theme
/// 앱 하나의 시각 언어 전체.
///
/// SH의 설계 전제는 **시그니처는 고정, 색조만 앱마다 다름**이다.
/// 그래서 새 앱을 시작할 때 필요한 건 hue 하나뿐이고,
/// 나머지(타이포·모양·깊이·모션)는 기본값이 시그니처를 그대로 들고 온다.
///
/// ```swift
/// // 프리셋으로 시작
/// ContentView().shTheme(.lavender)
///
/// // 새 앱 색조
/// ContentView().shTheme(SHTheme(hue: 312))
/// ```
public struct SHTheme: Sendable {
    public let colors: SHColorScheme
    public let typography: SHTypographyScheme
    public let shape: SHShapeScheme
    public let elevation: SHElevationScheme
    public let motion: SHMotionScheme

    public init(
        colors: SHColorScheme,
        typography: SHTypographyScheme = .signature,
        shape: SHShapeScheme = .signature,
        elevation: SHElevationScheme? = nil,
        motion: SHMotionScheme = .signature
    ) {
        self.colors = colors
        self.typography = typography
        self.shape = shape
        // 그림자 색은 브랜드 hue를 머금어야 해서 팔레트에서 끌어온다.
        self.elevation = elevation ?? .signature(shadow: colors.shadow)
        self.motion = motion
    }

    /// 색조 하나로 테마를 만든다. 앱을 새로 만들 때 쓰는 기본 진입점.
    /// - Parameter hue: 0~360.
    public init(hue: Double, secondaryHueShift: Double = 55) {
        self.init(colors: .pastel(hue: hue, secondaryHueShift: secondaryHueShift))
    }
}

// MARK: - Presets

public extension SHTheme {
    static let lavender = SHTheme(hue: 268)
    static let pink     = SHTheme(hue: 340)
    static let mint     = SHTheme(hue: 166)
    static let peach    = SHTheme(hue: 22)
    static let sky      = SHTheme(hue: 205)
    static let lemon    = SHTheme(hue: 48)

    /// 카탈로그·스냅샷 테스트에서 전체를 순회할 때 쓴다.
    static let presets: [(name: String, theme: SHTheme)] = [
        ("Lavender", .lavender),
        ("Pink", .pink),
        ("Mint", .mint),
        ("Peach", .peach),
        ("Sky", .sky),
        ("Lemon", .lemon)
    ]
}

// MARK: - Environment

private struct SHThemeKey: EnvironmentKey {
    static let defaultValue: SHTheme = .lavender
}

public extension EnvironmentValues {
    var shTheme: SHTheme {
        get { self[SHThemeKey.self] }
        set { self[SHThemeKey.self] = newValue }
    }
}

public extension View {
    /// 테마를 하위 트리에 주입한다. 앱 루트에서 한 번 호출하면 된다.
    func shTheme(_ theme: SHTheme) -> some View {
        environment(\.shTheme, theme)
    }

    /// 색조만 바꿔 주입하는 축약형.
    func shTheme(hue: Double) -> some View {
        environment(\.shTheme, SHTheme(hue: hue))
    }
}
