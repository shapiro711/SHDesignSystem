import SwiftUI

// MARK: - Header Style

public enum SHHeaderStyle: String, Sendable, CaseIterable {
    case standard
    case large
    case glass

    public var displayName: String { rawValue.capitalized }
}

// MARK: - SHHeader

public struct SHHeader<Leading: View, Trailing: View>: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let subtitle: String?
    private let style: SHHeaderStyle
    private let leading: Leading
    private let trailing: Trailing

    public init(
        _ title: String,
        subtitle: String? = nil,
        style: SHHeaderStyle = .standard,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.leading = leading()
        self.trailing = trailing()
    }

    public var body: some View {
        Group {
            switch style {
            case .standard, .glass: inlineHeader
            case .large: largeHeader
            }
        }
        .background(background)
    }

    private var inlineHeader: some View {
        HStack(spacing: SH.spacing.sm) {
            leading

            VStack(alignment: .leading, spacing: SH.spacing.xxxs) {
                SHText(title, \.titleLarge, lineLimit: 1)
                    .accessibilityAddTraits(.isHeader)
                if let subtitle {
                    SHText(subtitle, \.bodySmall, role: .secondary, lineLimit: 1)
                }
            }

            Spacer(minLength: SH.spacing.xs)

            trailing
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.vertical, SH.spacing.xs)
        .frame(minHeight: SH.size.minTapTarget + SH.spacing.xs)
    }

    private var largeHeader: some View {
        VStack(alignment: .leading, spacing: SH.spacing.sm) {
            HStack {
                leading
                Spacer()
                trailing
            }

            VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                SHText(title, \.displaySmall)
                    .accessibilityAddTraits(.isHeader)
                if let subtitle {
                    SHText(subtitle, \.bodyMedium, role: .secondary)
                }
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.vertical, SH.spacing.md)
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .standard, .large: theme.colors.background
        case .glass: Rectangle().fill(.ultraThinMaterial)
        }
    }
}

// MARK: - Convenience Inits

public extension SHHeader where Leading == EmptyView, Trailing == EmptyView {
    init(_ title: String, subtitle: String? = nil, style: SHHeaderStyle = .standard) {
        self.init(title, subtitle: subtitle, style: style,
                  leading: { EmptyView() }, trailing: { EmptyView() })
    }
}

public extension SHHeader where Leading == EmptyView {
    init(
        _ title: String,
        subtitle: String? = nil,
        style: SHHeaderStyle = .standard,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.init(title, subtitle: subtitle, style: style,
                  leading: { EmptyView() }, trailing: trailing)
    }
}

// MARK: - SHNavigationHeader

public struct SHNavigationHeader: View {
    @Environment(\.dismiss) private var dismiss

    private let title: String
    private let style: SHHeaderStyle
    private let showsBackButton: Bool
    private let trailingIcon: String?
    private let trailingLabel: String?
    private let onTrailingTap: (() -> Void)?

    public init(
        _ title: String,
        style: SHHeaderStyle = .standard,
        showsBackButton: Bool = true,
        trailingIcon: String? = nil,
        trailingLabel: String? = nil,
        onTrailingTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.showsBackButton = showsBackButton
        self.trailingIcon = trailingIcon
        self.trailingLabel = trailingLabel
        self.onTrailingTap = onTrailingTap
    }

    public var body: some View {
        SHHeader(title, style: style) {
            if showsBackButton {
                SHIconButton(icon: "chevron.left", accessibilityLabel: "뒤로") {
                    dismiss()
                }
            }
        } trailing: {
            if let trailingIcon {
                SHIconButton(
                    icon: trailingIcon,
                    accessibilityLabel: trailingLabel ?? "추가 동작"
                ) {
                    onTrailingTap?()
                }
            }
        }
    }
}

// MARK: - SHSectionHeader

public struct SHSectionHeader: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(_ title: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        HStack {
            SHText(title, \.titleSmall)
                .accessibilityAddTraits(.isHeader)

            Spacer()

            if let actionTitle, let action {
                Button(action: action) {
                    SHText(actionTitle, \.labelMedium, role: .brand)
                }
                .buttonStyle(.shPressable(haptic: nil))
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.vertical, SH.spacing.xs)
    }
}

// MARK: - Preview

#Preview("Headers") {
    VStack(spacing: 0) {
        SHNavigationHeader("설정", trailingIcon: "ellipsis", trailingLabel: "더 보기")
        SHDivider()
        SHHeader("오늘의 기록", subtitle: "3개의 항목", style: .large)
        SHSectionHeader("최근", actionTitle: "모두 보기") {}
        Spacer()
    }
    .background(SHThemeBackground())
    .shTheme(.mint)
}
