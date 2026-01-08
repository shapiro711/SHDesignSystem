import SwiftUI

// MARK: - Header Style
public enum SHHeaderStyle: String, CaseIterable, Sendable {
    case standard
    case large
    case glass

    public var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .large: return "Large"
        case .glass: return "Glass"
        }
    }
}

// MARK: - SHHeader
public struct SHHeader<LeadingAction: View, TrailingAction: View>: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let subtitle: String?
    private let style: SHHeaderStyle
    private let leadingAction: LeadingAction?
    private let trailingAction: TrailingAction?

    public init(
        _ title: String,
        subtitle: String? = nil,
        style: SHHeaderStyle = .standard,
        @ViewBuilder leadingAction: () -> LeadingAction = { EmptyView() },
        @ViewBuilder trailingAction: () -> TrailingAction = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leadingAction = leadingAction()
        self.trailingAction = trailingAction()
    }

    public var body: some View {
        VStack(spacing: 0) {
            switch style {
            case .standard:
                standardHeader
            case .large:
                largeHeader
            case .glass:
                glassHeader
            }
        }
    }

    private var standardHeader: some View {
        HStack(spacing: SH.spacing.md) {
            if let leadingAction = leadingAction, !(leadingAction is EmptyView) {
                leadingAction
            }

            VStack(alignment: .leading, spacing: SH.spacing.xxxs) {
                Text(title)
                    .font(SH.typography.titleLarge)
                    .foregroundStyle(SH.colors.textPrimary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(SH.typography.bodySmall)
                        .foregroundStyle(SH.colors.textSecondary)
                }
            }

            Spacer()

            if let trailingAction = trailingAction, !(trailingAction is EmptyView) {
                trailingAction
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.vertical, SH.spacing.sm)
        .background(SH.colors.background)
    }

    private var largeHeader: some View {
        VStack(alignment: .leading, spacing: SH.spacing.sm) {
            HStack {
                if let leadingAction = leadingAction, !(leadingAction is EmptyView) {
                    leadingAction
                }

                Spacer()

                if let trailingAction = trailingAction, !(trailingAction is EmptyView) {
                    trailingAction
                }
            }

            VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                Text(title)
                    .font(SH.typography.displaySmall)
                    .foregroundStyle(SH.colors.textPrimary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(SH.typography.bodyMedium)
                        .foregroundStyle(SH.colors.textSecondary)
                }
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.vertical, SH.spacing.md)
        .background(SH.colors.background)
    }

    private var glassHeader: some View {
        HStack(spacing: SH.spacing.md) {
            if let leadingAction = leadingAction, !(leadingAction is EmptyView) {
                leadingAction
            }

            VStack(alignment: .leading, spacing: SH.spacing.xxxs) {
                Text(title)
                    .font(SH.typography.titleLarge)
                    .foregroundStyle(SH.colors.textPrimary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(SH.typography.bodySmall)
                        .foregroundStyle(SH.colors.textSecondary)
                }
            }

            Spacer()

            if let trailingAction = trailingAction, !(trailingAction is EmptyView) {
                trailingAction
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.vertical, SH.spacing.sm)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Simple Init
public extension SHHeader where LeadingAction == EmptyView, TrailingAction == EmptyView {
    init(
        _ title: String,
        subtitle: String? = nil,
        style: SHHeaderStyle = .standard
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leadingAction = nil
        self.trailingAction = nil
    }
}

// MARK: - Navigation Header
public struct SHNavigationHeader: View {
    @Environment(\.shTheme) private var theme
    @Environment(\.dismiss) private var dismiss

    private let title: String
    private let style: SHHeaderStyle
    private let showBackButton: Bool
    private let trailingIcon: String?
    private let onTrailingTap: (() -> Void)?

    public init(
        _ title: String,
        style: SHHeaderStyle = .standard,
        showBackButton: Bool = true,
        trailingIcon: String? = nil,
        onTrailingTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.showBackButton = showBackButton
        self.trailingIcon = trailingIcon
        self.onTrailingTap = onTrailingTap
    }

    public var body: some View {
        SHHeader(title, style: style) {
            if showBackButton {
                SHIconButton(icon: "chevron.left", style: .ghost, size: .medium) {
                    dismiss()
                }
            }
        } trailingAction: {
            if let icon = trailingIcon {
                SHIconButton(icon: icon, style: .ghost, size: .medium) {
                    onTrailingTap?()
                }
            }
        }
    }
}

// MARK: - Section Header
public struct SHSectionHeader: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(
        _ title: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(SH.typography.titleSmall)
                .foregroundStyle(SH.colors.textPrimary)

            Spacer()

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(SH.typography.labelMedium)
                        .foregroundStyle(theme.primaryColor)
                }
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.vertical, SH.spacing.sm)
    }
}

// MARK: - Preview
#Preview("SHHeader Styles") {
    VStack(spacing: 0) {
        ForEach(SHHeaderStyle.allCases, id: \.self) { style in
            SHHeader("헤더 타이틀", subtitle: style.displayName, style: style) {
                SHIconButton(icon: "chevron.left", style: .ghost) {}
            } trailingAction: {
                SHIconButton(icon: "ellipsis", style: .ghost) {}
            }
            Divider()
        }
    }
    .shTheme(.pastelLavender)
}

#Preview("SHNavigationHeader") {
    VStack(spacing: 0) {
        SHNavigationHeader("설정", trailingIcon: "gear")
        Spacer()
    }
    .shTheme(.pastelPink)
}

#Preview("SHSectionHeader") {
    VStack(spacing: 16) {
        SHSectionHeader("최근 항목", actionTitle: "모두 보기") {}
        SHSectionHeader("추천")
    }
    .shTheme(.pastelMint)
}
