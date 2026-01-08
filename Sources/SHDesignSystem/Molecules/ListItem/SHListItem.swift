import SwiftUI

// MARK: - ListItem Style
public enum SHListItemStyle: String, CaseIterable, Sendable {
    case standard
    case card
    case glass

    public var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .card: return "Card"
        case .glass: return "Glass"
        }
    }
}

// MARK: - SHListItem
public struct SHListItem<Leading: View, Trailing: View>: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let subtitle: String?
    private let style: SHListItemStyle
    private let leading: Leading?
    private let trailing: Trailing?
    private let action: (() -> Void)?

    public init(
        _ title: String,
        subtitle: String? = nil,
        style: SHListItemStyle = .standard,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() },
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leading = leading()
        self.trailing = trailing()
        self.action = action
    }

    public var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    content
                }
                .buttonStyle(.plain)
            } else {
                content
            }
        }
    }

    private var content: some View {
        HStack(spacing: SH.spacing.md) {
            if let leading = leading, !(leading is EmptyView) {
                leading
            }

            VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                Text(title)
                    .font(SH.typography.bodyLarge)
                    .foregroundStyle(SH.colors.textPrimary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(SH.typography.bodySmall)
                        .foregroundStyle(SH.colors.textSecondary)
                }
            }

            Spacer()

            if let trailing = trailing, !(trailing is EmptyView) {
                trailing
            }
        }
        .padding(SH.spacing.md)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: style == .standard ? 0 : SH.radius.xl, style: .continuous))
        .overlay(overlayView)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .standard:
            Color.clear
        case .card:
            SH.colors.surface
        case .glass:
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .fill(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        switch style {
        case .standard:
            EmptyView()
        case .card:
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .stroke(SH.colors.border, lineWidth: 1)
        case .glass:
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .stroke(SH.colors.glassBorder, lineWidth: 1)
        }
    }
}

// MARK: - Simple Init (no generics)
public extension SHListItem where Leading == EmptyView, Trailing == EmptyView {
    init(
        _ title: String,
        subtitle: String? = nil,
        style: SHListItemStyle = .standard,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leading = nil
        self.trailing = nil
        self.action = action
    }
}

// MARK: - Navigation ListItem
public struct SHNavigationListItem: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let style: SHListItemStyle
    private let action: () -> Void

    public init(
        _ title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        style: SHListItemStyle = .standard,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.style = style
        self.action = action
    }

    public var body: some View {
        SHListItem(title, subtitle: subtitle, style: style) {
            if let icon = icon {
                SHCircledIcon(icon, size: .md, style: .filled)
            }
        } trailing: {
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(SH.colors.textTertiary)
        } action: {
            action()
        }
    }
}

// MARK: - Toggle ListItem
public struct SHToggleListItem: View {
    @Environment(\.shTheme) private var theme

    @Binding private var isOn: Bool
    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let style: SHListItemStyle

    public init(
        _ title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        isOn: Binding<Bool>,
        style: SHListItemStyle = .standard
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self._isOn = isOn
        self.style = style
    }

    public var body: some View {
        SHListItem(title, subtitle: subtitle, style: style) {
            if let icon = icon {
                SHCircledIcon(icon, size: .md, style: .filled)
            }
        } trailing: {
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(theme.primaryColor)
        }
    }
}

// MARK: - Preview
#Preview("SHListItem Styles") {
    VStack(spacing: 16) {
        ForEach(SHListItemStyle.allCases, id: \.self) { style in
            SHListItem("리스트 아이템", subtitle: style.displayName, style: style) {
                SHCircledIcon("star.fill", size: .md, style: .filled)
            } trailing: {
                Text("값")
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .shTheme(.pastelLavender)
}

#Preview("Navigation & Toggle") {
    VStack(spacing: 12) {
        SHNavigationListItem("프로필 설정", subtitle: "이름, 사진 변경", icon: "person.fill") {}
        SHNavigationListItem("알림 설정", icon: "bell.fill") {}
        SHToggleListItem("다크 모드", icon: "moon.fill", isOn: .constant(true))
    }
    .padding()
    .shTheme(.pastelPink)
}
