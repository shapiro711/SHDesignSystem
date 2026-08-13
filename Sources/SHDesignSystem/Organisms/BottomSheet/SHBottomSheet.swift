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

/// 측정 전 첫 프레임에서 시트가 납작하게 뜨지 않도록 잡아 두는 하한.
private let minimumFittedHeight: CGFloat = 160

struct SHBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Environment(\.shTheme) private var theme

    @Binding var isPresented: Bool
    let detent: SHSheetDetent
    let showsDragIndicator: Bool
    let onDismiss: (() -> Void)?
    @ViewBuilder let sheetContent: () -> SheetContent

    /// 시트는 새 프레젠테이션 컨텍스트라 `\.shTheme`이 자동으로 이어지지 않는다.
    /// 그래서 명시적으로 다시 주입한다.
    ///
    /// **여기서 읽는 테마는 이 모디파이어가 붙은 자리의 바깥 환경 값이다.**
    /// 그래서 `.shTheme`은 반드시 이 모디파이어보다 **위**에 있어야 한다.
    /// 앱 루트(`WindowGroup` 바로 안)에서 한 번 거는 게 정답이다.
    ///
    /// ```swift
    /// // ✅ 루트에서 한 번 — 아래의 모든 시트가 테마를 받는다
    /// WindowGroup { RootView().shTheme(.sky) }
    ///
    /// // ❌ 프레젠테이션 모디파이어보다 아래에 걸면
    /// //    여기서 읽는 값은 환경 기본값(.lavender)이 되고
    /// //    시트만 라벤더로 뜬다
    /// TabView { … }
    ///     .shTheme(.sky)
    ///     .shBottomSheet(isPresented: $isOpen) { … }
    /// ```
    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented, onDismiss: onDismiss) {
            SheetBody(detent: detent, showsDragIndicator: showsDragIndicator, content: sheetContent)
                .shTheme(theme)
        }
    }

    private struct SheetBody: View {
        @Environment(\.shTheme) private var theme

        /// 내용의 자연 높이. 0이면 아직 측정 전이다.
        @State private var contentHeight: CGFloat = 0

        let detent: SHSheetDetent
        let showsDragIndicator: Bool
        @ViewBuilder let content: () -> SheetContent

        var body: some View {
            Group {
                if case .fitContent = detent {
                    fitContentBody
                } else {
                    content()
                        .presentationDetents([detent.presentationDetent])
                }
            }
            .presentationDragIndicator(showsDragIndicator ? .visible : .hidden)
            .presentationCornerRadius(theme.shape.sheet.radius(for: 0))
            .presentationBackground(theme.colors.surface)
        }

        /// 내용 높이를 **실제로 재서** detent에 반영한다.
        ///
        /// 예전에는 상수 320을 썼다. 그래서 내용이 그보다 길어지는 순간
        /// (예: 선택에 따라 행이 추가되는 시트) 위쪽이 잘려 나갔다.
        ///
        /// `ScrollView`로 감싸는 게 핵심이다. 두 가지를 동시에 해결한다.
        /// 1. 스크롤 뷰는 자식에게 높이를 무제한으로 제안하므로, detent가 아직
        ///    작아도 **자연 높이**가 측정된다. 감싸지 않으면 잘린 높이를 재고
        ///    그 값으로 detent를 정하는 악순환에 빠진다.
        /// 2. 내용이 화면보다 길면 `.height()` detent는 시스템이 상한으로 잘라 주는데,
        ///    그때 넘치는 부분이 잘리지 않고 스크롤된다.
        private var fitContentBody: some View {
            ScrollView {
                content()
                    .onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.size.height
                    } action: { height in
                        contentHeight = height
                    }
            }
            .scrollBounceBehavior(.basedOnSize)
            .presentationDetents([.height(fittedHeight)])
            // 높이가 바뀔 때 튀지 않게 한다 — 선택에 따라 행이 늘고 주는 시트에서 눈에 띈다
            .animation(theme.motion.standard, value: fittedHeight)
        }

        private var fittedHeight: CGFloat {
            max(contentHeight, minimumFittedHeight)
        }
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
