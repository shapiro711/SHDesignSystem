import SwiftUI
import UIKit

// MARK: - Border

struct SHBorderModifier: ViewModifier {
    @Environment(\.shTheme) private var theme

    let shape: SHCornerStyle
    let color: Color?
    let width: CGFloat

    func body(content: Content) -> some View {
        content.overlay(
            shape.shape.stroke(color ?? theme.colors.border, lineWidth: width)
        )
    }
}

public extension View {
    func shBorder(
        _ shape: SHCornerStyle,
        color: Color? = nil,
        width: CGFloat = SH.size.border
    ) -> some View {
        modifier(SHBorderModifier(shape: shape, color: color, width: width))
    }
}

// MARK: - Layout Helpers

public extension View {
    func shFullWidth(alignment: Alignment = .center) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }

    func shSquare(_ size: CGFloat) -> some View {
        frame(width: size, height: size)
    }

    /// HIG 최소 터치 영역을 보장한다. 아이콘 버튼처럼 시각 크기가
    /// 작은 요소에 반드시 붙인다.
    func shMinTapTarget() -> some View {
        frame(minWidth: SH.size.minTapTarget, minHeight: SH.size.minTapTarget)
            .contentShape(Rectangle())
    }
}

// MARK: - Accessibility

public extension View {
    func shAccessible(label: String, hint: String? = nil) -> some View {
        accessibilityLabel(Text(label))
            .accessibilityHint(hint.map(Text.init) ?? Text(""))
    }
}

// MARK: - Keyboard

public extension View {
    /// 빈 곳을 탭하면 키보드를 내린다.
    func shDismissKeyboardOnTap() -> some View {
        onTapGesture { SHKeyboard.dismiss() }
    }
}

public enum SHKeyboard {
    @MainActor
    public static func dismiss() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
