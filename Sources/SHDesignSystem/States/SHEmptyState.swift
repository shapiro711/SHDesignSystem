import SwiftUI

// MARK: - SHEmptyState
/// 리스트가 비었을 때 보여주는 화면.
/// 실앱에서 이게 없으면 "빈 스크롤뷰"가 그대로 노출된다.
public struct SHEmptyState: View {
    @Environment(\.shTheme) private var theme

    private let icon: String
    private let title: String
    private let message: String?
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(
        icon: String = "tray",
        title: String,
        message: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: SH.spacing.md) {
            SHCircledIcon(icon, size: .xl, role: .tinted)

            VStack(spacing: SH.spacing.xs) {
                SHText(title, \.titleLarge, alignment: .center)
                if let message {
                    SHText(message, \.bodyMedium, role: .secondary, alignment: .center)
                }
            }

            if let actionTitle, let action {
                SHButton(actionTitle, variant: .secondary, action: action)
                    .padding(.top, SH.spacing.xs)
            }
        }
        .padding(SH.spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .contain)
    }
}

// MARK: - SHErrorState

/// 실패한 화면. 재시도 동작을 항상 노출한다.
public struct SHErrorState: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let message: String?
    private let retryTitle: String
    private let onRetry: (() -> Void)?

    public init(
        title: String = "문제가 발생했어요",
        message: String? = nil,
        retryTitle: String = "다시 시도",
        onRetry: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: SH.spacing.md) {
            ZStack {
                Circle()
                    .fill(theme.colors.errorContainer)
                    .frame(width: SH.size.iconXXL + SH.spacing.lg,
                           height: SH.size.iconXXL + SH.spacing.lg)
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: SH.size.iconXL, weight: .semibold))
                    .foregroundStyle(theme.colors.onErrorContainer)
            }
            .accessibilityHidden(true)

            VStack(spacing: SH.spacing.xs) {
                SHText(title, \.titleLarge, alignment: .center)
                if let message {
                    SHText(message, \.bodyMedium, role: .secondary, alignment: .center)
                }
            }

            if let onRetry {
                SHButton(retryTitle, icon: "arrow.clockwise", variant: .secondary, action: onRetry)
                    .padding(.top, SH.spacing.xs)
            }
        }
        .padding(SH.spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Async State Container

/// 로딩·에러·빈 상태·성공을 한 곳에서 분기한다.
/// 화면마다 같은 if/else를 반복하지 않게 하는 것이 목적이다.
public enum SHLoadState<Value>: Sendable where Value: Sendable {
    case idle
    case loading
    case loaded(Value)
    case failed(String)
}

public struct SHStateView<Value: Sendable, Content: View>: View {
    private let state: SHLoadState<Value>
    private let isEmpty: (Value) -> Bool
    private let emptyState: SHEmptyState?
    private let onRetry: (() -> Void)?
    private let content: (Value) -> Content

    public init(
        _ state: SHLoadState<Value>,
        isEmpty: @escaping (Value) -> Bool = { _ in false },
        emptyState: SHEmptyState? = nil,
        onRetry: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.state = state
        self.isEmpty = isEmpty
        self.emptyState = emptyState
        self.onRetry = onRetry
        self.content = content
    }

    public var body: some View {
        switch state {
        case .idle:
            Color.clear
        case .loading:
            SHLoadingView()
        case .loaded(let value):
            if isEmpty(value), let emptyState {
                emptyState
            } else {
                content(value)
            }
        case .failed(let message):
            SHErrorState(message: message, onRetry: onRetry)
        }
    }
}

public extension SHStateView where Value: Collection {
    init(
        _ state: SHLoadState<Value>,
        emptyState: SHEmptyState? = nil,
        onRetry: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.init(state, isEmpty: { $0.isEmpty }, emptyState: emptyState,
                  onRetry: onRetry, content: content)
    }
}

// MARK: - Preview

#Preview("Empty & Error") {
    TabView {
        SHEmptyState(
            icon: "note.text",
            title: "아직 기록이 없어요",
            message: "첫 기록을 남겨보세요.",
            actionTitle: "기록 추가"
        ) {}
        .background(SHThemeBackground())
        .tabItem { Label("Empty", systemImage: "tray") }

        SHErrorState(message: "네트워크 연결을 확인해주세요.") {}
            .background(SHThemeBackground())
            .tabItem { Label("Error", systemImage: "xmark") }
    }
    .shTheme(.lavender)
}
