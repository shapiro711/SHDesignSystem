import SwiftUI

// MARK: - Title Style

public enum SHNavigationTitleStyle: Sendable, CaseIterable {
    case inline
    case large

    var displayMode: NavigationBarItem.TitleDisplayMode {
        switch self {
        case .inline: return .inline
        case .large: return .large
        }
    }
}

// MARK: - Toolbar Button

/// 네비게이션 바에 넣는 아이콘 버튼.
///
/// 툴바 안에서는 `SHIconButton`을 쓰면 안 된다. 그쪽은 자기 배경(원형 채움·테두리)을
/// 직접 그리므로 유리 바 위에 불투명한 원이 하나 더 얹힌다. 여기서는 배경 없는
/// 아이콘만 두고, 캡슐 배경과 유리 처리는 시스템에 맡긴다.
public struct SHToolbarButton: View {
    private let icon: String
    private let accessibilityLabel: String
    private let role: ButtonRole?
    private let action: () -> Void

    /// - Parameter accessibilityLabel: 아이콘만 있는 버튼은 VoiceOver가 읽을
    ///   텍스트가 없다. 그래서 선택 항목이 아니라 **필수 인자**다.
    public init(
        icon: String,
        accessibilityLabel: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.accessibilityLabel = accessibilityLabel
        self.role = role
        self.action = action
    }

    public var body: some View {
        Button(role: role, action: action) {
            Image(systemName: icon)
        }
        .accessibilityLabel(Text(accessibilityLabel))
    }
}

// MARK: - Navigation Bar

public extension View {
    /// 시스템 네비게이션 바에 타이틀과 좌·우 액션을 얹는다.
    ///
    /// 바 자체는 그리지 않는다. 시스템이 리퀴드 글래스로 렌더링하고,
    /// 스크롤 가장자리 반응도 시스템이 처리한다.
    /// 뒤로 가기 버튼과 스와이프 back 제스처도 `NavigationStack`이 알아서 준다 —
    /// 직접 그리지 말고 `NavigationStack` 안에서 이 모디파이어만 붙인다.
    /// 액션이 여러 개면 클로저 안에 **그냥 나란히 둔다.** `HStack`으로 묶지 않는다 —
    /// 묶으면 iOS 26이 그 묶음을 컨트롤 하나로 보고 유리 캡슐을 하나만 씌워서
    /// 버튼들이 한 알약 안에 붙어 버린다. `ToolbarItemGroup`이 각각을 별도 항목으로
    /// 펼쳐 주므로 간격과 유리 처리는 시스템이 맡는다.
    ///
    /// ```swift
    /// .shNavigationBar("2026년 8월") {
    ///     SHToolbarButton(icon: "chevron.left", accessibilityLabel: "이전 달") { }
    /// } trailing: {
    ///     SHToolbarButton(icon: "chevron.right", accessibilityLabel: "다음 달") { }
    ///     Button("오늘") { }
    /// }
    /// ```
    func shNavigationBar<Leading: View, Trailing: View>(
        _ title: String,
        style: SHNavigationTitleStyle = .inline,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        let leadingContent = leading()
        let trailingContent = trailing()

        return shTitle(title, style: style)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) { leadingContent }
                ToolbarItemGroup(placement: .topBarTrailing) { trailingContent }
            }
    }

    /// 툴바 항목을 직접 구성한다.
    ///
    /// iOS 26은 **인접한 툴바 항목을 유리 캡슐 하나로 묶는다.** 관련된 액션끼리
    /// 묶이는 게 기본값이라 대개는 그대로 두면 되지만, 성격이 다른 액션을 각자
    /// 캡슐에 담으려면 사이에 `ToolbarSpacer`를 넣어야 한다.
    /// `ToolbarSpacer`는 `View`가 아니라 `ToolbarContent`라 `trailing:` 클로저로는
    /// 표현할 수 없다 — 그래서 이 통로를 연다.
    ///
    /// ```swift
    /// .shNavigationBar("2026년 8월") {
    ///     ToolbarItem(placement: .topBarTrailing) {
    ///         SHToolbarButton(icon: "chevron.right", accessibilityLabel: "다음 달") { }
    ///     }
    ///     ToolbarSpacer(.fixed, placement: .topBarTrailing)   // 캡슐을 나눈다
    ///     ToolbarItem(placement: .topBarTrailing) {
    ///         Button("오늘") { }
    ///     }
    /// }
    /// ```
    func shNavigationBar<Content: ToolbarContent>(
        _ title: String,
        style: SHNavigationTitleStyle = .inline,
        @ToolbarContentBuilder toolbar: () -> Content
    ) -> some View {
        shTitle(title, style: style)
            .toolbar(content: toolbar)
    }

    /// 타이틀만. 툴바 항목을 만들지 않으므로 뒤로 가기 버튼 자리를 건드리지 않는다.
    func shNavigationBar(
        _ title: String,
        style: SHNavigationTitleStyle = .inline
    ) -> some View {
        shTitle(title, style: style)
    }

    /// 타이틀 + 우측 액션.
    func shNavigationBar<Trailing: View>(
        _ title: String,
        style: SHNavigationTitleStyle = .inline,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        let trailingContent = trailing()

        return shTitle(title, style: style)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) { trailingContent }
            }
    }

    /// 타이틀 + 우측 아이콘 버튼 하나. 가장 흔한 형태의 축약형이다.
    func shNavigationBar(
        _ title: String,
        style: SHNavigationTitleStyle = .inline,
        trailingIcon: String,
        trailingLabel: String,
        onTrailingTap: @escaping () -> Void
    ) -> some View {
        shNavigationBar(title, style: style) {
            SHToolbarButton(
                icon: trailingIcon,
                accessibilityLabel: trailingLabel,
                action: onTrailingTap
            )
        }
    }
}

private extension View {
    func shTitle(_ title: String, style: SHNavigationTitleStyle) -> some View {
        navigationTitle(title)
            .navigationBarTitleDisplayMode(style.displayMode)
    }
}

// MARK: - Preview

#Preview("Navigation Bar") {
    NavigationStack {
        SHScreen {
            ScrollView {
                VStack(spacing: SH.spacing.md) {
                    ForEach(0..<20, id: \.self) { index in
                        SHCard {
                            SHText("항목 \(index)", \.bodyLarge)
                        }
                    }
                }
                .padding(SH.spacing.md)
            }
        }
        .shNavigationBar(
            "기록",
            style: .large,
            trailingIcon: "plus",
            trailingLabel: "기록 추가"
        ) {}
    }
    .shTheme(.lavender)
}
