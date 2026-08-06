import SwiftUI

// MARK: - SHDialog
/// 중앙 모달 다이얼로그. 시스템 `alert`과 달리 시그니처 룩을 유지한다.
public struct SHDialog: View {
    @Environment(\.shTheme) private var theme
    @Environment(\.shDismiss) private var dismiss

    private let icon: String?
    private let title: String
    private let message: String?
    private let primary: Action
    private let secondary: Action?

    public struct Action {
        public let title: String
        public let role: Role
        public let handler: () -> Void

        public enum Role: Sendable { case normal, destructive, cancel }

        public init(_ title: String, role: Role = .normal, handler: @escaping () -> Void = {}) {
            self.title = title
            self.role = role
            self.handler = handler
        }

        var variant: SHButtonVariant {
            switch role {
            case .normal: return .primary
            case .destructive: return .destructive
            case .cancel: return .ghost
            }
        }
    }

    public init(
        icon: String? = nil,
        title: String,
        message: String? = nil,
        primary: Action,
        secondary: Action? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.primary = primary
        self.secondary = secondary
    }

    public var body: some View {
        VStack(spacing: SH.spacing.md) {
            if let icon {
                SHCircledIcon(icon, size: .lg, role: .tinted)
            }

            VStack(spacing: SH.spacing.xs) {
                SHText(title, \.titleLarge, alignment: .center)
                    .accessibilityAddTraits(.isHeader)
                if let message {
                    SHText(message, \.bodyMedium, role: .secondary, alignment: .center)
                }
            }
            .shFullWidth()

            VStack(spacing: SH.spacing.xs) {
                SHButton(primary.title, variant: primary.variant, fillsWidth: true) {
                    primary.handler()
                    dismiss()
                }
                if let secondary {
                    SHButton(secondary.title, variant: secondary.variant, fillsWidth: true) {
                        secondary.handler()
                        dismiss()
                    }
                }
            }
            .padding(.top, SH.spacing.xxs)
        }
        .padding(SH.spacing.lg)
        .frame(maxWidth: 340)
        .shSurface(.elevated, shape: theme.shape.card)
        .shShadow(theme.elevation.overlay)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }
}

// MARK: - Presentation

struct SHDialogModifier<DialogContent: View>: ViewModifier {
    @Environment(\.shTheme) private var theme

    @Binding var isPresented: Bool
    let dismissOnBackgroundTap: Bool
    @ViewBuilder let dialog: () -> DialogContent

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ZStack {
                        theme.colors.scrim
                            .ignoresSafeArea()
                            .onTapGesture {
                                guard dismissOnBackgroundTap else { return }
                                isPresented = false
                            }
                            .accessibilityHidden(true)

                        dialog()
                            .padding(SH.spacing.xl)
                            .environment(\.shDismiss, SHDismissAction { isPresented = false })
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.94)))
                }
            }
            .animation(theme.motion.emphasized, value: isPresented)
    }
}

public extension View {
    func shDialog<Content: View>(
        isPresented: Binding<Bool>,
        dismissOnBackgroundTap: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            SHDialogModifier(
                isPresented: isPresented,
                dismissOnBackgroundTap: dismissOnBackgroundTap,
                dialog: content
            )
        )
    }
}

// MARK: - Dismiss Bridge

/// SwiftUI의 `DismissAction`은 직접 만들 수 없다.
/// 시트가 아닌 오버레이(다이얼로그)에서도 같은 방식으로 닫을 수 있도록
/// 환경값으로 닫기 동작을 내려보낸다.
public struct SHDismissAction: Sendable {
    private let action: @MainActor @Sendable () -> Void

    public init(_ action: @escaping @MainActor @Sendable () -> Void) {
        self.action = action
    }

    @MainActor
    public func callAsFunction() { action() }
}

private struct SHDismissKey: EnvironmentKey {
    static let defaultValue = SHDismissAction {}
}

public extension EnvironmentValues {
    var shDismiss: SHDismissAction {
        get { self[SHDismissKey.self] }
        set { self[SHDismissKey.self] = newValue }
    }
}

// MARK: - Preview

#Preview("Dialog") {
    struct Demo: View {
        @State private var isPresented = false

        var body: some View {
            SHScreen {
                SHButton("삭제하기", variant: .destructive) { isPresented = true }
            }
            .shDialog(isPresented: $isPresented) {
                SHDialog(
                    icon: "trash.fill",
                    title: "정말 삭제할까요?",
                    message: "삭제한 기록은 되돌릴 수 없어요.",
                    primary: .init("삭제", role: .destructive),
                    secondary: .init("취소", role: .cancel)
                )
            }
        }
    }
    return Demo().shTheme(.pink)
}
