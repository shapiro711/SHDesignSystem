import SwiftUI

// MARK: - SHListItem
/// 리스트 한 줄. leading/trailing은 제네릭이라 `EmptyView` 여부가
/// 컴파일 타임에 결정된다. 런타임 타입 검사(`is EmptyView`)를 하지 않으므로
/// 뷰 아이덴티티가 깨지지 않는다.
public struct SHListItem<Leading: View, Trailing: View>: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let subtitle: String?
    private let surface: SHSurfaceRole
    private let leading: Leading
    private let trailing: Trailing
    private let action: (() -> Void)?

    public init(
        _ title: String,
        subtitle: String? = nil,
        surface: SHSurfaceRole = .plain,
        action: (() -> Void)? = nil,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.subtitle = subtitle
        self.surface = surface
        self.action = action
        self.leading = leading()
        self.trailing = trailing()
    }

    public var body: some View {
        if let action {
            Button(action: action) { row }
                .buttonStyle(.shPressable(haptic: nil))
                .accessibilityElement(children: .combine)
        } else {
            row
        }
    }

    private var row: some View {
        HStack(spacing: SH.spacing.md) {
            leading

            VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                SHText(title, \.bodyLarge)
                if let subtitle {
                    SHText(subtitle, \.bodySmall, role: .secondary)
                }
            }

            Spacer(minLength: SH.spacing.xs)

            trailing
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.vertical, SH.spacing.sm)
        .frame(minHeight: SH.size.minTapTarget)
        .shSurface(surface, shape: surface == .plain ? .rounded(0) : theme.shape.container)
    }
}

// MARK: - Convenience Inits

public extension SHListItem where Leading == EmptyView, Trailing == EmptyView {
    init(
        _ title: String,
        subtitle: String? = nil,
        surface: SHSurfaceRole = .plain,
        action: (() -> Void)? = nil
    ) {
        self.init(title, subtitle: subtitle, surface: surface, action: action,
                  leading: { EmptyView() }, trailing: { EmptyView() })
    }
}

public extension SHListItem where Trailing == EmptyView {
    init(
        _ title: String,
        subtitle: String? = nil,
        surface: SHSurfaceRole = .plain,
        action: (() -> Void)? = nil,
        @ViewBuilder leading: () -> Leading
    ) {
        self.init(title, subtitle: subtitle, surface: surface, action: action,
                  leading: leading, trailing: { EmptyView() })
    }
}

// MARK: - Navigation Row

public struct SHNavigationRow: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let value: String?
    private let surface: SHSurfaceRole
    private let action: () -> Void

    public init(
        _ title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        value: String? = nil,
        surface: SHSurfaceRole = .plain,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.value = value
        self.surface = surface
        self.action = action
    }

    public var body: some View {
        SHListItem(title, subtitle: subtitle, surface: surface, action: action) {
            if let icon {
                SHCircledIcon(icon, size: .md, role: .tinted)
            }
        } trailing: {
            HStack(spacing: SH.spacing.xs) {
                if let value {
                    SHText(value, \.bodyMedium, role: .secondary)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: SH.size.iconSM, weight: .semibold))
                    .foregroundStyle(theme.colors.textTertiary)
                    .accessibilityHidden(true)
            }
        }
    }
}

// MARK: - Toggle Row

public struct SHToggleRow: View {
    @Environment(\.shTheme) private var theme

    @Binding private var isOn: Bool

    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let surface: SHSurfaceRole

    public init(
        _ title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        isOn: Binding<Bool>,
        surface: SHSurfaceRole = .plain
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self._isOn = isOn
        self.surface = surface
    }

    public var body: some View {
        SHListItem(title, subtitle: subtitle, surface: surface) {
            if let icon {
                SHCircledIcon(icon, size: .md, role: .tinted)
            }
        } trailing: {
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(theme.colors.primary)
                .onChange(of: isOn) { _, _ in SHHaptics.selection() }
        }
        // Toggle 자신이 스위치 트레잇을 갖고, 제목은 라벨로 합쳐진다.
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(title))
    }
}

// MARK: - Preview

#Preview("Rows") {
    ScrollView {
        VStack(spacing: SH.spacing.sm) {
            SHNavigationRow("프로필 설정", subtitle: "이름, 사진 변경", icon: "person.fill") {}
            SHNavigationRow("알림", icon: "bell.fill", value: "켜짐") {}
            SHToggleRow("다크 모드", icon: "moon.fill", isOn: .constant(true))
            SHDivider(inset: SH.spacing.md)
            SHNavigationRow("카드형", icon: "square.stack.fill", surface: .elevated) {}
            SHNavigationRow("틴트형", icon: "sparkles", surface: .tinted) {}
        }
        .padding(.vertical)
    }
    .background(SHThemeBackground())
    .shTheme(.lavender)
}
