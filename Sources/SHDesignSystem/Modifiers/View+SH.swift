import SwiftUI

// MARK: - Shadow Modifiers
public extension View {
    func shShadow(
        color: Color = .black.opacity(0.1),
        radius: CGFloat = 16,
        x: CGFloat = 0,
        y: CGFloat = 4
    ) -> some View {
        self.shadow(color: color, radius: radius, x: x, y: y)
    }

    func shSoftShadow() -> some View {
        self.shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 8)
    }

    func shElevation(_ level: Int) -> some View {
        let radius = CGFloat(level * 4)
        let opacity = 0.05 + (Double(level) * 0.02)
        return self.shadow(color: .black.opacity(opacity), radius: radius, x: 0, y: CGFloat(level))
    }
}

// MARK: - Border Modifiers
public extension View {
    func shBorder(
        color: Color = SH.colors.border,
        width: CGFloat = 1,
        cornerRadius: CGFloat = SH.radius.xl
    ) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(color, lineWidth: width)
        )
    }

    func shAccentBorder(cornerRadius: CGFloat = SH.radius.xl) -> some View {
        self.modifier(AccentBorderModifier(cornerRadius: cornerRadius))
    }
}

struct AccentBorderModifier: ViewModifier {
    @Environment(\.shTheme) private var theme
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(theme.primaryColor, lineWidth: 2)
        )
    }
}

// MARK: - Animation Modifiers
public extension View {
    func shSpringAnimation() -> some View {
        self.animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID())
    }

    func shBounceAnimation() -> some View {
        self.animation(.interpolatingSpring(stiffness: 200, damping: 15), value: UUID())
    }
}

// MARK: - Conditional Modifiers
public extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func ifLet<Value, Content: View>(_ value: Value?, transform: (Self, Value) -> Content) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}

// MARK: - Accessibility Modifiers
public extension View {
    func shAccessible(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }

    func shTappable(label: String, action: @escaping () -> Void) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isButton)
            .onTapGesture(perform: action)
    }
}

// MARK: - Hide Keyboard
public extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            hideKeyboard()
        }
    }
}
