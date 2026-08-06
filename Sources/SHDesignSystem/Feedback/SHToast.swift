import SwiftUI

// MARK: - Toast Model

public struct SHToast: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let message: String
    public let kind: SHStatusKind
    public let icon: String?
    public let duration: Duration

    public init(
        _ message: String,
        kind: SHStatusKind = .info,
        icon: String? = nil,
        duration: Duration = .seconds(2.4)
    ) {
        self.message = message
        self.kind = kind
        self.icon = icon
        self.duration = duration
    }

    public static func success(_ message: String) -> SHToast {
        SHToast(message, kind: .success, icon: "checkmark.circle.fill")
    }

    public static func error(_ message: String) -> SHToast {
        SHToast(message, kind: .error, icon: "exclamationmark.circle.fill")
    }

    public static func info(_ message: String) -> SHToast {
        SHToast(message, kind: .info, icon: "info.circle.fill")
    }

    var resolvedIcon: String {
        if let icon { return icon }
        switch kind {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "exclamationmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

// MARK: - Toast View

struct SHToastView: View {
    @Environment(\.shTheme) private var theme

    let toast: SHToast

    var body: some View {
        HStack(spacing: SH.spacing.sm) {
            Image(systemName: toast.resolvedIcon)
                .font(.system(size: SH.size.iconMD, weight: .semibold))
                .foregroundStyle(theme.colors.onContainer(for: toast.kind))
                .accessibilityHidden(true)

            SHText(toast.message, \.bodyMedium, role: .status(toast.kind))
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.vertical, SH.spacing.sm)
        .shSurface(.status(toast.kind), shape: theme.shape.chip)
        .shShadow(theme.elevation.floating)
        .padding(.horizontal, SH.spacing.md)
    }
}

// MARK: - Presentation

public enum SHToastEdge: Sendable {
    case top, bottom
}

struct SHToastModifier: ViewModifier {
    @Environment(\.shTheme) private var theme

    @Binding var toast: SHToast?
    let edge: SHToastEdge

    func body(content: Content) -> some View {
        content
            .overlay(alignment: edge == .top ? .top : .bottom) {
                if let toast {
                    SHToastView(toast: toast)
                        .transition(
                            .move(edge: edge == .top ? .top : .bottom)
                            .combined(with: .opacity)
                        )
                        // VoiceOver가 자동으로 읽도록 알림으로 올린다.
                        .accessibilityAddTraits(.isStaticText)
                        .accessibilityLabel(Text(toast.message))
                        .task(id: toast.id) {
                            try? await Task.sleep(for: toast.duration)
                            self.toast = nil
                        }
                }
            }
            .animation(theme.motion.emphasized, value: toast)
    }
}

public extension View {
    /// 토스트를 띄운다. `toast`가 nil이 되면 사라진다.
    /// 표시 시간이 지나면 스스로 nil로 되돌린다.
    func shToast(_ toast: Binding<SHToast?>, edge: SHToastEdge = .bottom) -> some View {
        modifier(SHToastModifier(toast: toast, edge: edge))
    }
}

// MARK: - Preview

#Preview("Toast") {
    struct Demo: View {
        @State private var toast: SHToast?

        var body: some View {
            SHScreen {
                VStack(spacing: SH.spacing.md) {
                    SHButton("성공", variant: .secondary) { toast = .success("저장했어요") }
                    SHButton("에러", variant: .secondary) { toast = .error("저장에 실패했어요") }
                    SHButton("정보", variant: .secondary) { toast = .info("동기화 중이에요") }
                }
            }
            .shToast($toast)
        }
    }
    return Demo().shTheme(.peach)
}
