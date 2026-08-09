import SwiftUI

// MARK: - Header Style

public enum SHHeaderStyle: String, Sendable, CaseIterable {
    case standard
    case large

    public var displayName: String { rawValue.capitalized }
}

// MARK: - SHHeader

/// **콘텐츠 안에 놓는** 헤더. 화면 상단의 네비게이션 바가 아니다.
///
/// 네비게이션 바 타이틀은 `shNavigationBar(_:)`로 시스템 바에 넘긴다. 이건
/// 스크롤과 함께 밀려 올라가는 섹션 히어로 — 리스트 위 인사말, 카드 묶음의
/// 제목 같은 자리에 쓴다.
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
            case .standard: inlineHeader
            case .large: largeHeader
            }
        }
        .background(theme.colors.background)
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
    NavigationStack {
        SHScreen {
            VStack(spacing: 0) {
                SHHeader("오늘의 기록", subtitle: "3개의 항목", style: .large)
                SHDivider()
                SHHeader("최근 활동", subtitle: "Standard") {
                    SHIconButton(icon: "ellipsis", accessibilityLabel: "더 보기") {}
                }
                SHSectionHeader("최근", actionTitle: "모두 보기") {}
                Spacer()
            }
        }
        .shNavigationBar("설정", trailingIcon: "ellipsis", trailingLabel: "더 보기") {}
    }
    .shTheme(.mint)
}
