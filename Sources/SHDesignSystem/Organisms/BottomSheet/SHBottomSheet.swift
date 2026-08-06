import SwiftUI

// MARK: - Detent

public enum SHSheetDetent: Sendable, Equatable {
    case compact        // 화면의 30%
    case medium
    case large
    case fraction(CGFloat)
    /// 내용 높이에 맞춤. 액션 시트에 쓴다.
    case fitContent

    var presentationDetent: PresentationDetent {
        switch self {
        case .compact: return .fraction(0.3)
        case .medium: return .medium
        case .large: return .large
        case .fraction(let value): return .fraction(value)
        case .fitContent: return .medium
        }
    }
}

// MARK: - Sheet Modifier

struct SHBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Environment(\.shTheme) private var theme

    @Binding var isPresented: Bool
    let detent: SHSheetDetent
    let showsDragIndicator: Bool
    let onDismiss: (() -> Void)?
    @ViewBuilder let sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented, onDismiss: onDismiss) {
            SheetBody(detent: detent, showsDragIndicator: showsDragIndicator, content: sheetContent)
                // 시트는 새 프레젠테이션 컨텍스트라 환경이 자동으로
                // 이어지지 않는 경우가 있다. 테마를 명시적으로 다시 주입한다.
                .shTheme(theme)
        }
    }

    private struct SheetBody: View {
        @Environment(\.shTheme) private var theme

        let detent: SHSheetDetent
        let showsDragIndicator: Bool
        @ViewBuilder let content: () -> SheetContent

        var body: some View {
            Group {
                if case .fitContent = detent {
                    content()
                        .presentationDetents([.height(fittedHeight)])
                } else {
                    content()
                        .presentationDetents([detent.presentationDetent])
                }
            }
            .presentationDragIndicator(showsDragIndicator ? .visible : .hidden)
            .presentationCornerRadius(theme.shape.sheet.radius(for: 0))
            .presentationBackground(theme.colors.surface)
        }

        /// `.fitContent`는 SwiftUI가 직접 지원하지 않아 근사값을 쓴다.
        /// 정확한 높이가 필요하면 `.fraction`을 지정한다.
        private var fittedHeight: CGFloat { 320 }
    }
}

public extension View {
    func shBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        detent: SHSheetDetent = .medium,
        showsDragIndicator: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            SHBottomSheetModifier(
                isPresented: isPresented,
                detent: detent,
                showsDragIndicator: showsDragIndicator,
                onDismiss: onDismiss,
                sheetContent: content
            )
        )
    }
}

// MARK: - SHActionSheet

public struct SHActionSheet: View {
    @Environment(\.shTheme) private var theme
    @Environment(\.dismiss) private var dismiss

    private let title: String?
    private let message: String?
    private let actions: [Action]
    private let cancelTitle: String?

    public struct Action: Identifiable {
        public let id = UUID()
        public let title: String
        public let icon: String?
        public let role: Role
        public let handler: () -> Void

        public enum Role: Sendable { case normal, destructive }

        public init(
            _ title: String,
            icon: String? = nil,
            role: Role = .normal,
            handler: @escaping () -> Void
        ) {
            self.title = title
            self.icon = icon
            self.role = role
            self.handler = handler
        }
    }

    public init(
        title: String? = nil,
        message: String? = nil,
        actions: [Action],
        cancelTitle: String? = "취소"
    ) {
        self.title = title
        self.message = message
        self.actions = actions
        self.cancelTitle = cancelTitle
    }

    public var body: some View {
        VStack(spacing: SH.spacing.md) {
            if title != nil || message != nil {
                VStack(spacing: SH.spacing.xxs) {
                    if let title {
                        SHText(title, \.titleMedium, alignment: .center)
                            .accessibilityAddTraits(.isHeader)
                    }
                    if let message {
                        SHText(message, \.bodySmall, role: .secondary, alignment: .center)
                    }
                }
                .shFullWidth()
                .padding(.top, SH.spacing.lg)
            }

            VStack(spacing: SH.spacing.xs) {
                ForEach(actions) { action in
                    button(for: action)
                }
            }

            if let cancelTitle {
                SHButton(cancelTitle, variant: .ghost, fillsWidth: true) { dismiss() }
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.bottom, SH.spacing.lg)
    }

    private func button(for action: Action) -> some View {
        SHButton(
            action.title,
            icon: action.icon,
            variant: action.role == .destructive ? .destructive : .secondary,
            fillsWidth: true
        ) {
            action.handler()
            dismiss()
        }
    }
}

// MARK: - Preview

#Preview("Bottom Sheet") {
    struct Demo: View {
        @State private var isPresented = false

        var body: some View {
            SHScreen {
                SHButton("시트 열기", icon: "square.and.arrow.up") { isPresented = true }
            }
            .shBottomSheet(isPresented: $isPresented, detent: .fitContent) {
                SHActionSheet(
                    title: "파일 옵션",
                    message: "이 파일로 무엇을 하시겠어요?",
                    actions: [
                        .init("공유", icon: "square.and.arrow.up") {},
                        .init("복사", icon: "doc.on.doc") {},
                        .init("삭제", icon: "trash", role: .destructive) {}
                    ]
                )
            }
        }
    }
    return Demo().shTheme(.pink)
}
