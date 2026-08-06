import SwiftUI

// MARK: - Motion Scheme
/// 애니메이션도 토큰이다. 컴포넌트마다 spring 파라미터를 따로 쓰면
/// 앱 전체의 "손맛"이 어긋난다.
public struct SHMotionScheme: Sendable {
    /// 토글, 체크처럼 즉각 반응해야 하는 것.
    public let quick: Animation
    /// 기본 전환.
    public let standard: Animation
    /// 시트, 화면 전환처럼 존재감 있는 움직임.
    public let emphasized: Animation
    /// 눌렀을 때 줄어드는 비율.
    public let pressedScale: CGFloat
    /// 눌렀을 때 투명도.
    public let pressedOpacity: Double

    public init(
        quick: Animation,
        standard: Animation,
        emphasized: Animation,
        pressedScale: CGFloat,
        pressedOpacity: Double
    ) {
        self.quick = quick
        self.standard = standard
        self.emphasized = emphasized
        self.pressedScale = pressedScale
        self.pressedOpacity = pressedOpacity
    }

    /// 시그니처: 탄력 있고 살짝 통통 튀는 감각.
    public static let signature = SHMotionScheme(
        quick: .spring(response: 0.24, dampingFraction: 0.86),
        standard: .spring(response: 0.36, dampingFraction: 0.78),
        emphasized: .spring(response: 0.48, dampingFraction: 0.74),
        pressedScale: 0.96,
        pressedOpacity: 0.88
    )
}
