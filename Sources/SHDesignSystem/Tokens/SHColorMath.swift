import SwiftUI
import UIKit

// MARK: - RGBA
/// 색 계산 중간 표현. Color/UIColor 대신 순수 값으로 다뤄야
/// 대비 계산과 Sendable 전파가 모두 안전하다.
public struct SHRGBA: Sendable, Equatable {
    public var red: Double
    public var green: Double
    public var blue: Double
    public var alpha: Double

    public init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public func opacity(_ value: Double) -> SHRGBA {
        SHRGBA(red: red, green: green, blue: blue, alpha: value)
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}

// MARK: - Color Math
/// 팔레트를 손으로 찍지 않고 hue 하나에서 생성하기 위한 계산 유틸.
///
/// `accessibleFill`/`accessibleInk`는 목표 대비에 닿을 때까지 밝기를 미는 탐색이다.
/// 다만 밝기 범위(0.12~1.0)를 다 쓰고도 목표에 못 닿으면 그 지점에서 멈추므로,
/// 반환값의 `contrast`를 확인하기 전까지 AA 통과가 보장되는 건 아니다.
public enum SHColorMath {

    // MARK: HSB → RGB

    public static func hsb(_ hue: Double, _ saturation: Double, _ brightness: Double, alpha: Double = 1) -> SHRGBA {
        let ui = UIColor(
            hue: (hue.truncatingRemainder(dividingBy: 360)) / 360,
            saturation: saturation,
            brightness: brightness,
            alpha: 1
        )
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        return SHRGBA(red: Double(r), green: Double(g), blue: Double(b), alpha: alpha)
    }

    // MARK: WCAG

    /// WCAG 2.1 상대 휘도.
    public static func relativeLuminance(_ c: SHRGBA) -> Double {
        func linearize(_ v: Double) -> Double {
            v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * linearize(c.red)
             + 0.7152 * linearize(c.green)
             + 0.0722 * linearize(c.blue)
    }

    /// WCAG 2.1 대비비. 1.0 ~ 21.0
    public static func contrastRatio(_ a: SHRGBA, _ b: SHRGBA) -> Double {
        let la = relativeLuminance(a)
        let lb = relativeLuminance(b)
        return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)
    }

    /// WCAG AA 본문 기준.
    public static let aaText: Double = 4.5
    /// WCAG AA 큰 텍스트 / UI 컴포넌트 기준.
    public static let aaLarge: Double = 3.0

    // MARK: Accessible Fill

    public struct FillResult: Sendable {
        public let fill: SHRGBA
        public let on: SHRGBA
        public let contrast: Double
    }

    /// 주어진 hue로 채움색을 만들되, 밝기를 조정해 전경색과의 대비가
    /// `target` 이상이 되도록 보장한다.
    ///
    /// 밝은 전경(`onLight`)과 어두운 전경(`onDark`) 중 시작점에서 더 유리한 쪽을
    /// 먼저 고르고, 그 방향으로만 밝기를 움직인다. 그래서 레몬(노랑) 계열은
    /// "밝은 배경 + 어두운 글씨", 라벤더 계열은 "진한 배경 + 흰 글씨"로
    /// 자연스럽게 갈린다.
    public static func accessibleFill(
        hue: Double,
        saturation: Double,
        brightness: Double,
        onLight: SHRGBA,
        onDark: SHRGBA,
        target: Double = aaText
    ) -> FillResult {
        let start = hsb(hue, saturation, brightness)
        let preferLight = contrastRatio(start, onLight) >= contrastRatio(start, onDark)
        let on = preferLight ? onLight : onDark

        // 밝은 글씨를 쓸 거면 배경을 어둡게, 어두운 글씨를 쓸 거면 배경을 밝게.
        let step: Double = preferLight ? -0.01 : 0.01

        var b = brightness
        var candidate = start
        var ratio = contrastRatio(candidate, on)

        while ratio < target, b > 0.12, b < 1.0 {
            b += step
            candidate = hsb(hue, saturation, min(max(b, 0), 1))
            ratio = contrastRatio(candidate, on)
        }

        return FillResult(fill: candidate, on: on, contrast: ratio)
    }

    /// 지정한 배경 위에서 `target` 대비를 만족할 때까지 밝기를 조정한 전경색.
    ///
    /// 채움색과 달리 이쪽은 "배경이 고정"이다. 고스트 버튼 글자, 링크,
    /// 섹션 액션처럼 표면 위에 브랜드 색으로 글씨를 쓸 때 쓴다.
    /// `primary`(채움색)를 그대로 글자색으로 쓰면 노랑 계열에서 무조건 깨진다.
    public static func accessibleInk(
        hue: Double,
        saturation: Double,
        brightness: Double,
        against background: SHRGBA,
        target: Double = aaText
    ) -> SHRGBA {
        // 배경이 밝으면 잉크를 어둡게, 어두우면 밝게.
        let backgroundIsLight = relativeLuminance(background) > 0.35
        let step: Double = backgroundIsLight ? -0.02 : 0.02

        var b = brightness
        var candidate = hsb(hue, saturation, b)

        while contrastRatio(candidate, background) < target, b > 0.08, b < 1.0 {
            b += step
            candidate = hsb(hue, saturation, min(max(b, 0), 1))
        }
        return candidate
    }

    // MARK: Adaptive Color

    /// 라이트/다크 값을 담은 동적 Color.
    /// 클로저가 캡처하는 건 Sendable한 값 타입뿐이라 strict concurrency에 안전하다.
    public static func adaptive(light: SHRGBA, dark: SHRGBA) -> Color {
        Color(UIColor { traits in
            let c = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat(c.red),
                green: CGFloat(c.green),
                blue: CGFloat(c.blue),
                alpha: CGFloat(c.alpha)
            )
        })
    }
}
