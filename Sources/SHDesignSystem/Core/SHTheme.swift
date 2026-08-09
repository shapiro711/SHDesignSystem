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

    /// 이 테마를 만든 색조(0~360).
    ///
    /// 색조 하나로 만든 테마만 값을 갖는다. 팔레트를 직접 넘겨 만든 테마는 `nil`이다.
    ///
    /// 앱은 보통 이 값을 설정에 저장했다가 다시 주입한다. 이게 없으면 앱마다
    /// "어떤 색조를 쓰고 있는지" 표를 따로 들고 있어야 해서, 테마 선택 UI를
    /// 만들 때마다 프리셋 목록이 중복된다.
    public let hue: Double?

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
        self.hue = nil
    }

    /// 색조 하나로 테마를 만든다. 앱을 새로 만들 때 쓰는 기본 진입점.
    /// - Parameter hue: 0~360.
    public init(hue: Double, secondaryHueShift: Double = 55) {
        self.colors = .pastel(hue: hue, secondaryHueShift: secondaryHueShift)
        self.typography = .signature
        self.shape = .signature
        self.elevation = .signature(shadow: colors.shadow)
        self.motion = .signature
        self.hue = hue
    }

    /// 같은 색조인지 비교한다. 테마 선택 UI에서 현재 선택을 판정할 때 쓴다.
    /// - Parameter tolerance: 부동소수 오차 허용치
    public func hasSameHue(as other: SHTheme, tolerance: Double = 0.5) -> Bool {
        guard let lhs = hue, let rhs = other.hue else { return false }
        return abs(lhs - rhs) < tolerance
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
    ///
    /// `SHThemePicker`가 이 목록을 그대로 그린다.
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
    ///
    /// `tint`도 함께 건다. SH 컴포넌트는 각자 브랜드색을 칠하지만,
    /// 네비게이션 바·탭바·`DatePicker`처럼 시스템이 직접 그리는 것들은
    /// tint가 없으면 iOS 기본색(파랑)으로 렌더링돼 화면에서 혼자 튄다.
    ///
    /// 값은 `primary`가 아니라 **`primaryText`**다. 시스템은 tint를 거의 항상
    /// 전경색으로 쓴다 — 탭바 선택 아이콘, 툴바 버튼, 링크. `primary`는 배경으로
    /// 깔았을 때 대비를 맞춘 채움색이라 밝은 색조에서 표면 위 전경으로 쓰면 묻힌다.
    /// (README "primary를 글자색으로 쓰면 안 됩니다"와 같은 이유다.)
    func shTheme(_ theme: SHTheme) -> some View {
        environment(\.shTheme, theme)
            .tint(theme.colors.primaryText)
    }

    /// 색조만 바꿔 주입하는 축약형.
    func shTheme(hue: Double) -> some View {
        shTheme(SHTheme(hue: hue))
    }
}
