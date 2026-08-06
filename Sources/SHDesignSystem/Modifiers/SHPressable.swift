import SwiftUI
import UIKit

// MARK: - Haptics

@MainActor
public enum SHHaptics {
    /// 앱 설정에서 햅틱을 끌 수 있게 노출한다.
    public static var isEnabled = true

    public static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    public static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    public static func selection() {
        guard isEnabled else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

// MARK: - Pressable Button Style
/// 누름 피드백을 시스템 전체에 통일한다.
///
/// 이전 구현은 `.buttonStyle(.plain)`이라 눌림 반응이 전혀 없었다.
/// `ButtonStyle`을 쓰면 `configuration.isPressed`를 SwiftUI가 관리해주고,
/// `.disabled()`와 접근성 트레잇도 자동으로 따라온다.
public struct SHPressableButtonStyle: ButtonStyle {
    @Environment(\.shTheme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    private let haptic: UIImpactFeedbackGenerator.FeedbackStyle?

    public init(haptic: UIImpactFeedbackGenerator.FeedbackStyle? = .light) {
        self.haptic = haptic
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? theme.motion.pressedScale : 1)
            .opacity(pressedOpacity(configuration.isPressed))
            .animation(theme.motion.quick, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, pressed in
                guard pressed, let haptic else { return }
                SHHaptics.impact(haptic)
            }
    }

    private func pressedOpacity(_ isPressed: Bool) -> Double {
        // 비활성 표현은 ButtonStyle이 아니라 컴포넌트가 담당한다.
        // 여기서 겹쳐 곱하면 두 번 흐려진다.
        guard isEnabled else { return 1 }
        return isPressed ? theme.motion.pressedOpacity : 1
    }
}

public extension ButtonStyle where Self == SHPressableButtonStyle {
    static var shPressable: SHPressableButtonStyle { SHPressableButtonStyle() }

    static func shPressable(haptic: UIImpactFeedbackGenerator.FeedbackStyle?) -> SHPressableButtonStyle {
        SHPressableButtonStyle(haptic: haptic)
    }
}

// MARK: - Disabled Presentation

struct SHDisabledModifier: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled

    func body(content: Content) -> some View {
        content
            .opacity(isEnabled ? 1 : 0.42)
            .saturation(isEnabled ? 1 : 0.4)
    }
}

public extension View {
    /// 비활성 시각 표현. 상태 자체는 `.disabled(_:)`가 관리하므로
    /// 접근성 트레잇이 VoiceOver에 정상 전달된다.
    func shDisabledAppearance() -> some View {
        modifier(SHDisabledModifier())
    }
}
