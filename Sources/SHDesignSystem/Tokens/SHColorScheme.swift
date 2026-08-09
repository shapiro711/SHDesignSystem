import SwiftUI

// MARK: - Color Scheme
/// 시맨틱 컬러 역할 집합. 컴포넌트는 원시 색이 아니라 **역할**만 참조한다.
///
/// `primary`(채움색)와 `primaryContainer`(파스텔 틴트)를 분리한 것이 핵심이다.
/// 파스텔은 대비상 채움색이 될 수 없으므로 컨테이너 역할만 맡고,
/// 채움색은 같은 hue에서 대비를 만족하도록 계산해 뽑는다.
public struct SHColorScheme: Sendable {

    // MARK: Brand
    public let primary: Color
    public let onPrimary: Color
    public let primaryContainer: Color
    public let onPrimaryContainer: Color
    /// 선택/호버 배경처럼 아주 옅게 깔 때 쓰는 틴트.
    public let primarySubtle: Color
    /// **표면 위에 쓰는** 브랜드 글자색. 고스트 버튼, 링크, 섹션 액션.
    /// `primary`(채움색)를 글자색으로 재사용하면 밝은 색조에서 대비가 무너진다.
    public let primaryText: Color

    public let secondary: Color
    public let onSecondary: Color
    public let secondaryContainer: Color
    public let onSecondaryContainer: Color

    // MARK: Surfaces
    public let background: Color
    public let surface: Color
    public let surfaceElevated: Color
    public let surfaceSunken: Color

    // MARK: Content
    public let textPrimary: Color
    public let textSecondary: Color
    public let textTertiary: Color
    public let textDisabled: Color

    // MARK: Lines
    public let border: Color
    public let borderStrong: Color
    public let divider: Color

    // MARK: Status
    public let success: Color
    public let onSuccess: Color
    public let successContainer: Color
    public let onSuccessContainer: Color

    public let warning: Color
    public let onWarning: Color
    public let warningContainer: Color
    public let onWarningContainer: Color

    public let error: Color
    public let onError: Color
    public let errorContainer: Color
    public let onErrorContainer: Color

    public let info: Color
    public let onInfo: Color
    public let infoContainer: Color
    public let onInfoContainer: Color

    // MARK: Effects
    public let glassBorder: Color
    public let scrim: Color
    public let shadow: Color
}

// MARK: - Generation

public extension SHColorScheme {

    /// hue 하나에서 전체 시맨틱 팔레트를 생성한다.
    /// 앱을 새로 만들 때 바꾸는 값은 이 `hue` 하나뿐이다.
    ///
    /// - Parameters:
    ///   - hue: 0~360. 브랜드 색조.
    ///   - secondaryHueShift: 보조 색조 회전각. 시그니처는 유사색(+55°).
    static func pastel(hue: Double, secondaryHueShift: Double = 55) -> SHColorScheme {
        let brand = SHBrandRamp(hue: hue)
        let accent = SHBrandRamp(hue: hue + secondaryHueShift)

        // 중립색도 브랜드 hue를 아주 살짝 머금게 해서 화면 전체가 한 덩어리로 보이게 한다.
        let neutral = SHNeutralRamp(hue: hue)

        return SHColorScheme(
            primary: brand.fill,
            onPrimary: brand.onFill,
            primaryContainer: brand.container,
            onPrimaryContainer: brand.onContainer,
            primarySubtle: brand.subtle,
            primaryText: brand.ink,

            secondary: accent.fill,
            onSecondary: accent.onFill,
            secondaryContainer: accent.container,
            onSecondaryContainer: accent.onContainer,

            background: neutral.background,
            surface: neutral.surface,
            surfaceElevated: neutral.surfaceElevated,
            surfaceSunken: neutral.surfaceSunken,

            textPrimary: neutral.textPrimary,
            textSecondary: neutral.textSecondary,
            textTertiary: neutral.textTertiary,
            textDisabled: neutral.textDisabled,

            border: neutral.border,
            borderStrong: neutral.borderStrong,
            divider: neutral.divider,

            success: SHStatusRamp.success.fill,
            onSuccess: SHStatusRamp.success.onFill,
            successContainer: SHStatusRamp.success.container,
            onSuccessContainer: SHStatusRamp.success.onContainer,

            warning: SHStatusRamp.warning.fill,
            onWarning: SHStatusRamp.warning.onFill,
            warningContainer: SHStatusRamp.warning.container,
            onWarningContainer: SHStatusRamp.warning.onContainer,

            error: SHStatusRamp.error.fill,
            onError: SHStatusRamp.error.onFill,
            errorContainer: SHStatusRamp.error.container,
            onErrorContainer: SHStatusRamp.error.onContainer,

            info: SHStatusRamp.info.fill,
            onInfo: SHStatusRamp.info.onFill,
            infoContainer: SHStatusRamp.info.container,
            onInfoContainer: SHStatusRamp.info.onContainer,

            glassBorder: SHColorMath.adaptive(
                light: SHRGBA(red: 1, green: 1, blue: 1, alpha: 0.45),
                dark: SHRGBA(red: 1, green: 1, blue: 1, alpha: 0.18)
            ),
            scrim: SHColorMath.adaptive(
                light: SHRGBA(red: 0, green: 0, blue: 0, alpha: 0.32),
                dark: SHRGBA(red: 0, green: 0, blue: 0, alpha: 0.52)
            ),
            shadow: SHColorMath.adaptive(
                light: SHColorMath.hsb(hue, 0.30, 0.35, alpha: 0.14),
                dark: SHRGBA(red: 0, green: 0, blue: 0, alpha: 0.44)
            )
        )
    }
}

// MARK: - Brand Ramp

/// 하나의 hue에서 채움색/컨테이너/전경색을 뽑아내는 램프.
/// 라이트·다크 각각에서 대비를 따로 만족시킨다.
struct SHBrandRamp: Sendable {
    let fill: Color
    let onFill: Color
    let container: Color
    let onContainer: Color
    let subtle: Color
    /// 표면 위 글자색.
    let ink: Color

    init(hue: Double) {
        // 전경 후보. 순백/순흑 대신 hue를 머금은 값이라 눈이 덜 아프다.
        let lightInk = SHColorMath.hsb(hue, 0.05, 1.00)
        let darkInk  = SHColorMath.hsb(hue, 0.55, 0.20)

        // --- 채움색: 라이트 모드는 흰 배경 위, 다크 모드는 어두운 배경 위 ---
        let lightFill = SHColorMath.accessibleFill(
            hue: hue, saturation: 0.58, brightness: 0.78,
            onLight: lightInk, onDark: darkInk
        )
        let darkFill = SHColorMath.accessibleFill(
            hue: hue, saturation: 0.48, brightness: 0.82,
            onLight: lightInk, onDark: darkInk
        )

        fill = SHColorMath.adaptive(light: lightFill.fill, dark: darkFill.fill)
        onFill = SHColorMath.adaptive(light: lightFill.on, dark: darkFill.on)

        // --- 컨테이너: 시그니처 파스텔. 여기가 "몽글몽글"을 담당한다. ---
        let lightContainer = SHColorMath.hsb(hue, 0.20, 0.98)
        let darkContainer  = SHColorMath.hsb(hue, 0.38, 0.30)

        // 컨테이너 조합은 채움색과 달리 대비 탐색을 돌리지 않는다. 파스텔 톤을
        // 유지하는 게 시그니처라 밝기를 밀면 룩이 무너지기 때문이다. 대신 채도차를
        // 크게 벌린 고정값을 쓰고, hue 전 구간에서 7.9:1 이상이 나오는 걸 확인해 뒀다.
        let lightOnContainer = SHColorMath.hsb(hue, 0.80, 0.32)
        let darkOnContainer  = SHColorMath.hsb(hue, 0.22, 0.95)

        container = SHColorMath.adaptive(light: lightContainer, dark: darkContainer)
        onContainer = SHColorMath.adaptive(light: lightOnContainer, dark: darkOnContainer)

        subtle = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.12, 1.0),
            dark: SHColorMath.hsb(hue, 0.30, 0.22)
        )

        // 표면 위 글자색은 표면을 배경으로 두고 대비를 맞춘다.
        let lightSurface = SHColorMath.hsb(hue, 0.00, 1.00)
        let darkSurface = SHColorMath.hsb(hue, 0.12, 0.15)
        ink = SHColorMath.adaptive(
            light: SHColorMath.accessibleInk(
                hue: hue, saturation: 0.78, brightness: 0.52, against: lightSurface
            ),
            dark: SHColorMath.accessibleInk(
                hue: hue, saturation: 0.42, brightness: 0.80, against: darkSurface
            )
        )
    }
}

// MARK: - Neutral Ramp

struct SHNeutralRamp: Sendable {
    let background: Color
    let surface: Color
    let surfaceElevated: Color
    let surfaceSunken: Color
    let textPrimary: Color
    let textSecondary: Color
    let textTertiary: Color
    let textDisabled: Color
    let border: Color
    let borderStrong: Color
    let divider: Color

    init(hue: Double) {
        background = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.03, 0.99),
            dark: SHColorMath.hsb(hue, 0.14, 0.09)
        )
        surface = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.00, 1.00),
            dark: SHColorMath.hsb(hue, 0.12, 0.15)
        )
        surfaceElevated = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.00, 1.00),
            dark: SHColorMath.hsb(hue, 0.11, 0.20)
        )
        surfaceSunken = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.05, 0.96),
            dark: SHColorMath.hsb(hue, 0.16, 0.06)
        )

        textPrimary = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.30, 0.13),
            dark: SHColorMath.hsb(hue, 0.04, 0.97)
        )
        textSecondary = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.22, 0.42),
            dark: SHColorMath.hsb(hue, 0.08, 0.72)
        )
        textTertiary = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.16, 0.60),
            dark: SHColorMath.hsb(hue, 0.10, 0.55)
        )
        textDisabled = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.10, 0.75),
            dark: SHColorMath.hsb(hue, 0.10, 0.40)
        )

        border = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.18, 0.55, alpha: 0.22),
            dark: SHColorMath.hsb(hue, 0.10, 1.00, alpha: 0.16)
        )
        borderStrong = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.20, 0.45, alpha: 0.42),
            dark: SHColorMath.hsb(hue, 0.10, 1.00, alpha: 0.32)
        )
        divider = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.15, 0.60, alpha: 0.14),
            dark: SHColorMath.hsb(hue, 0.10, 1.00, alpha: 0.10)
        )
    }
}

// MARK: - Status Ramp

/// 상태색은 의미가 고정이라 앱별로 바뀌지 않는다.
/// 다만 파스텔 시그니처에 맞춰 컨테이너 톤은 부드럽게 유지한다.
struct SHStatusRamp: Sendable {
    let fill: Color
    let onFill: Color
    let container: Color
    let onContainer: Color

    init(hue: Double, saturation: Double = 0.68, brightness: Double = 0.72) {
        let lightInk = SHRGBA(red: 1, green: 1, blue: 1)
        let darkInk = SHColorMath.hsb(hue, 0.60, 0.18)

        let light = SHColorMath.accessibleFill(
            hue: hue, saturation: saturation, brightness: brightness,
            onLight: lightInk, onDark: darkInk
        )
        let dark = SHColorMath.accessibleFill(
            hue: hue, saturation: saturation - 0.12, brightness: brightness + 0.08,
            onLight: lightInk, onDark: darkInk
        )

        fill = SHColorMath.adaptive(light: light.fill, dark: dark.fill)
        onFill = SHColorMath.adaptive(light: light.on, dark: dark.on)
        container = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.22, 0.99),
            dark: SHColorMath.hsb(hue, 0.42, 0.28)
        )
        onContainer = SHColorMath.adaptive(
            light: SHColorMath.hsb(hue, 0.85, 0.34),
            dark: SHColorMath.hsb(hue, 0.24, 0.94)
        )
    }

    static let success = SHStatusRamp(hue: 148)
    static let warning = SHStatusRamp(hue: 38)
    static let error = SHStatusRamp(hue: 6)
    static let info = SHStatusRamp(hue: 210)
}
