import SwiftUI

// MARK: - Tab Badge

/// 탭에 붙는 배지.
///
/// `SHBadge`와 달리 `.dot`이 없다. 시스템 탭바는 점 배지를 그리지 않으므로
/// 있는 척하면 호출부가 조용히 아무것도 못 보게 된다.
public enum SHTabBadge: Sendable, Equatable {
    case count(Int)
    case text(String)

    var label: Text? {
        switch self {
        case .count(let value):
            return value > 0 ? Text(value.formatted()) : nil
        case .text(let text):
            return text.isEmpty ? nil : Text(text)
        }
    }
}

// MARK: - Tab Role

public enum SHTabRole: Sendable, Equatable {
    case standard
    /// 검색 탭. 탭바에서 떨어져 나와 독립된 유리 캡슐로 그려진다.
    case search

    var tabRole: TabRole? {
        switch self {
        case .standard: return nil
        case .search: return .search
        }
    }
}

// MARK: - Tab Item

public struct SHTabItem<Tag: Hashable>: Identifiable {
    public var id: Tag { tag }

    public let tag: Tag
    public let title: String
    public let icon: String
    public let selectedIcon: String?
    public let badge: SHTabBadge?
    public let role: SHTabRole

    public init(
        tag: Tag,
        title: String,
        icon: String,
        selectedIcon: String? = nil,
        badge: SHTabBadge? = nil,
        role: SHTabRole = .standard
    ) {
        self.tag = tag
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.badge = badge
        self.role = role
    }

    func symbol(isSelected: Bool) -> String {
        isSelected ? (selectedIcon ?? icon) : icon
    }
}

// MARK: - SHTabView

/// 탭 컨테이너. **탭바는 시스템이 리퀴드 글래스로 그린다.**
/// 디자인 시스템이 얹는 건 테마 tint 뿐이다.
///
/// 예전의 `SHTabBar`처럼 바를 직접 그리지 않는 이유가 있다. 리퀴드 글래스는
/// 바 뒤로 지나가는 콘텐츠의 굴절·명암·스크롤 가장자리 반응을 시스템이 매 프레임
/// 계산한다. `Material` 한 겹으로는 흉내 낼 수 없고, 흉내 내면 OS가 바뀔 때마다
/// 우리 것만 어긋난다. 그래서 시그니처 룩(선택 탭 파스텔 pill)을 포기하고
/// 시스템 바를 그대로 쓴다.
///
/// ```swift
/// SHTabView(items, selection: $selection) { tab in
///     switch tab {
///     case .home:  NavigationStack { HomeView() }
///     case .mine:  NavigationStack { MineView() }
///     }
/// }
/// ```
///
/// 각 탭의 콘텐츠는 자기 `NavigationStack`을 직접 갖는다. 탭 밖에 스택을 하나만
/// 두면 탭을 옮겨도 이전 탭의 푸시 스택이 남는다.
public struct SHTabView<Tag: Hashable, Content: View>: View {
    @Binding private var selection: Tag

    private let items: [SHTabItem<Tag>]
    private let minimizesOnScroll: Bool
    private let content: (Tag) -> Content

    /// - Parameter minimizesOnScroll: 아래로 스크롤할 때 탭바를 작은 캡슐로 접는다.
    ///   콘텐츠를 넓게 보여주는 화면(피드·지도)에서만 켜고, 탭 전환이 잦은 앱에서는
    ///   끈 채로 둔다.
    public init(
        _ items: [SHTabItem<Tag>],
        selection: Binding<Tag>,
        minimizesOnScroll: Bool = false,
        @ViewBuilder content: @escaping (Tag) -> Content
    ) {
        self.items = items
        self._selection = selection
        self.minimizesOnScroll = minimizesOnScroll
        self.content = content
    }

    public var body: some View {
        TabView(selection: $selection) {
            ForEach(items) { item in
                Tab(
                    item.title,
                    systemImage: item.symbol(isSelected: selection == item.tag),
                    value: item.tag,
                    role: item.role.tabRole
                ) {
                    content(item.tag)
                }
                .badge(item.badge?.label)
            }
        }
        .tabBarMinimizeBehavior(minimizesOnScroll ? .onScrollDown : .never)
    }
}

// MARK: - Preview

#Preview("Tab View") {
    struct Demo: View {
        @State private var selection = 0

        private let items = [
            SHTabItem(tag: 0, title: "홈", icon: "house", selectedIcon: "house.fill"),
            SHTabItem(tag: 1, title: "알림", icon: "bell", selectedIcon: "bell.fill", badge: .count(5)),
            SHTabItem(tag: 2, title: "내 정보", icon: "person", selectedIcon: "person.fill")
        ]

        var body: some View {
            SHTabView(items, selection: $selection) { tab in
                NavigationStack {
                    SHScreen {
                        ScrollView {
                            VStack(spacing: SH.spacing.md) {
                                ForEach(0..<20, id: \.self) { index in
                                    SHCard {
                                        SHText("탭 \(tab) · 항목 \(index)", \.bodyLarge)
                                    }
                                }
                            }
                            .padding(SH.spacing.md)
                        }
                    }
                    .shNavigationBar("탭 \(tab)")
                }
            }
        }
    }
    return Demo().shTheme(.mint)
}
