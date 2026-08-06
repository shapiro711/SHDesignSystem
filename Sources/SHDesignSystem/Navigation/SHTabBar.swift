import SwiftUI

// MARK: - Tab Item

public struct SHTabItem<Tag: Hashable>: Identifiable {
    public var id: Tag { tag }

    public let tag: Tag
    public let title: String
    public let icon: String
    public let selectedIcon: String?
    public let badge: SHBadge?

    public init(
        tag: Tag,
        title: String,
        icon: String,
        selectedIcon: String? = nil,
        badge: SHBadge? = nil
    ) {
        self.tag = tag
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.badge = badge
    }
}

// MARK: - SHTabBar

/// 커스텀 탭바. 시스템 `TabView`의 탭바는 시그니처 룩을 적용할 수 없어
/// 별도로 그린다. 화면 전환은 호출부가 `selection`으로 관리한다.
public struct SHTabBar<Tag: Hashable>: View {
    @Environment(\.shTheme) private var theme
    @Namespace private var namespace

    @Binding private var selection: Tag

    private let items: [SHTabItem<Tag>]

    public init(_ items: [SHTabItem<Tag>], selection: Binding<Tag>) {
        self.items = items
        self._selection = selection
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                tab(item)
            }
        }
        .padding(.horizontal, SH.spacing.xs)
        .padding(.top, SH.spacing.xs)
        .background {
            Rectangle()
                .fill(.regularMaterial)
                .overlay(alignment: .top) {
                    theme.colors.divider.frame(height: SH.size.divider)
                }
                .ignoresSafeArea(edges: .bottom)
        }
        .accessibilityElement(children: .contain)
    }

    private func tab(_ item: SHTabItem<Tag>) -> some View {
        let isSelected = selection == item.tag

        return Button {
            guard selection != item.tag else { return }
            selection = item.tag
            SHHaptics.selection()
        } label: {
            VStack(spacing: SH.spacing.xxs) {
                ZStack {
                    if isSelected {
                        theme.shape.chip.shape
                            .fill(theme.colors.primaryContainer)
                            .frame(width: 56, height: 30)
                            .matchedGeometryEffect(id: "sh.tab", in: namespace)
                    }

                    Image(systemName: isSelected ? (item.selectedIcon ?? item.icon) : item.icon)
                        .font(.system(size: SH.size.iconMD, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(isSelected ? theme.colors.onPrimaryContainer : theme.colors.textTertiary)
                        .shBadge(item.badge)
                }
                .frame(height: 30)

                Text(item.title)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .medium, design: .rounded))
                    .foregroundStyle(isSelected ? theme.colors.primaryText : theme.colors.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: SH.size.minTapTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(theme.motion.standard, value: selection)
        .accessibilityLabel(Text(item.title))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

// MARK: - Toolbar

/// 화면 하단에 고정되는 액션 바. 시트나 폼의 확정 버튼에 쓴다.
public struct SHBottomBar<Content: View>: View {
    @Environment(\.shTheme) private var theme

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            SHDivider()
            content
                .padding(.horizontal, SH.spacing.md)
                .padding(.vertical, SH.spacing.sm)
        }
        .background(.regularMaterial)
    }
}

// MARK: - Preview

#Preview("Tab Bar") {
    struct Demo: View {
        @State private var selection = 0

        var body: some View {
            VStack(spacing: 0) {
                SHScreen {
                    SHText("탭 \(selection)", \.headlineMedium)
                }

                SHTabBar(
                    [
                        SHTabItem(tag: 0, title: "홈", icon: "house", selectedIcon: "house.fill"),
                        SHTabItem(tag: 1, title: "탐색", icon: "magnifyingglass"),
                        SHTabItem(tag: 2, title: "알림", icon: "bell", selectedIcon: "bell.fill", badge: .count(5)),
                        SHTabItem(tag: 3, title: "내 정보", icon: "person", selectedIcon: "person.fill")
                    ],
                    selection: $selection
                )
            }
        }
    }
    return Demo().shTheme(.mint)
}
