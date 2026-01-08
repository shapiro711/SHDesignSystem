import SwiftUI

// MARK: - BottomSheet Detent
public enum SHBottomSheetDetent: Sendable {
    case small      // 25%
    case medium     // 50%
    case large      // 90%
    case custom(CGFloat)

    var fraction: CGFloat {
        switch self {
        case .small: return 0.25
        case .medium: return 0.5
        case .large: return 0.9
        case .custom(let value): return value
        }
    }
}

// MARK: - BottomSheet Style
public enum SHBottomSheetStyle: String, CaseIterable, Sendable {
    case standard
    case glass

    public var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .glass: return "Glass"
        }
    }
}

// MARK: - SHBottomSheet Modifier
public struct SHBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Environment(\.shTheme) private var theme

    @Binding private var isPresented: Bool
    private let detent: SHBottomSheetDetent
    private let style: SHBottomSheetStyle
    private let showDragIndicator: Bool
    private let onDismiss: (() -> Void)?
    private let sheetContent: SheetContent

    public init(
        isPresented: Binding<Bool>,
        detent: SHBottomSheetDetent = .medium,
        style: SHBottomSheetStyle = .standard,
        showDragIndicator: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.detent = detent
        self.style = style
        self.showDragIndicator = showDragIndicator
        self.onDismiss = onDismiss
        self.sheetContent = content()
    }

    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented, onDismiss: onDismiss) {
                sheetView
                    .presentationDetents([presentationDetent])
                    .presentationDragIndicator(showDragIndicator ? .visible : .hidden)
                    .presentationCornerRadius(SH.radius.xxxl)
                    .presentationBackground(backgroundMaterial)
            }
    }

    private var sheetView: some View {
        VStack(spacing: 0) {
            sheetContent
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var presentationDetent: PresentationDetent {
        switch detent {
        case .small:
            return .fraction(0.25)
        case .medium:
            return .medium
        case .large:
            return .large
        case .custom(let value):
            return .fraction(value)
        }
    }

    private var backgroundMaterial: AnyShapeStyle {
        switch style {
        case .standard:
            return AnyShapeStyle(SH.colors.surface)
        case .glass:
            return AnyShapeStyle(.ultraThinMaterial)
        }
    }
}

// MARK: - View Extension
public extension View {
    func shBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        detent: SHBottomSheetDetent = .medium,
        style: SHBottomSheetStyle = .standard,
        showDragIndicator: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            SHBottomSheetModifier(
                isPresented: isPresented,
                detent: detent,
                style: style,
                showDragIndicator: showDragIndicator,
                onDismiss: onDismiss,
                content: content
            )
        )
    }
}

// MARK: - Action Sheet Style BottomSheet
public struct SHActionSheet: View {
    @Environment(\.shTheme) private var theme

    private let title: String?
    private let message: String?
    private let actions: [Action]
    private let cancelAction: Action?

    public struct Action: Identifiable {
        public let id = UUID()
        public let title: String
        public let icon: String?
        public let style: ActionStyle
        public let handler: () -> Void

        public enum ActionStyle {
            case `default`
            case destructive
            case cancel
        }

        public init(
            _ title: String,
            icon: String? = nil,
            style: ActionStyle = .default,
            handler: @escaping () -> Void
        ) {
            self.title = title
            self.icon = icon
            self.style = style
            self.handler = handler
        }
    }

    public init(
        title: String? = nil,
        message: String? = nil,
        actions: [Action],
        cancelAction: Action? = nil
    ) {
        self.title = title
        self.message = message
        self.actions = actions
        self.cancelAction = cancelAction
    }

    public var body: some View {
        VStack(spacing: SH.spacing.md) {
            // Header
            if title != nil || message != nil {
                VStack(spacing: SH.spacing.xs) {
                    if let title = title {
                        Text(title)
                            .font(SH.typography.titleMedium)
                            .foregroundStyle(SH.colors.textPrimary)
                    }

                    if let message = message {
                        Text(message)
                            .font(SH.typography.bodySmall)
                            .foregroundStyle(SH.colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, SH.spacing.md)
            }

            // Actions
            VStack(spacing: SH.spacing.xs) {
                ForEach(actions) { action in
                    actionButton(action)
                }
            }
            .padding(.horizontal, SH.spacing.md)

            // Cancel
            if let cancelAction = cancelAction {
                SHDivider()
                    .padding(.vertical, SH.spacing.xs)

                actionButton(cancelAction)
                    .padding(.horizontal, SH.spacing.md)
            }
        }
        .padding(.bottom, SH.spacing.lg)
    }

    private func actionButton(_ action: Action) -> some View {
        Button {
            action.handler()
        } label: {
            HStack(spacing: SH.spacing.sm) {
                if let icon = action.icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                }

                Text(action.title)
                    .font(SH.typography.bodyLarge)
            }
            .foregroundStyle(actionColor(for: action.style))
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(actionBackground(for: action.style))
            .clipShape(RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func actionColor(for style: Action.ActionStyle) -> Color {
        switch style {
        case .default:
            return SH.colors.textPrimary
        case .destructive:
            return SH.colors.error
        case .cancel:
            return SH.colors.textSecondary
        }
    }

    private func actionBackground(for style: Action.ActionStyle) -> Color {
        switch style {
        case .default:
            return theme.primaryColor.opacity(0.1)
        case .destructive:
            return SH.colors.error.opacity(0.1)
        case .cancel:
            return SH.colors.surface
        }
    }
}

// MARK: - Preview
#Preview("SHBottomSheet") {
    struct PreviewWrapper: View {
        @State private var showSheet = false

        var body: some View {
            VStack {
                SHButton("Show Bottom Sheet", style: .primary) {
                    showSheet = true
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .shBottomSheet(isPresented: $showSheet, detent: .medium, style: .glass) {
                VStack(spacing: 16) {
                    Text("Bottom Sheet Content")
                        .font(SH.typography.titleLarge)
                    Text("여기에 컨텐츠가 들어갑니다.")
                        .font(SH.typography.bodyMedium)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .shTheme(.pastelLavender)
        }
    }
    return PreviewWrapper()
}

#Preview("SHActionSheet") {
    SHActionSheet(
        title: "파일 옵션",
        message: "이 파일로 무엇을 하시겠습니까?",
        actions: [
            .init("공유", icon: "square.and.arrow.up") {},
            .init("복사", icon: "doc.on.doc") {},
            .init("삭제", icon: "trash", style: .destructive) {}
        ],
        cancelAction: .init("취소", style: .cancel) {}
    )
    .shTheme(.pastelPink)
}
