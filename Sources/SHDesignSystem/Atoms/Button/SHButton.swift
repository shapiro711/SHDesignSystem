import SwiftUI

// MARK: - Button Variant

public enum SHButtonVariant: String, Sendable, CaseIterable {
    /// 화면당 하나. 브랜드 채움색.
    case primary
    /// 파스텔 컨테이너. 시그니처 룩이 가장 잘 드러나는 변형.
    case secondary
    /// 테두리만.
    case outlined
    /// 배경 없음.
    case ghost
    /// 파괴적 동작.
    case destructive
    /// 이미지·그라디언트 위.
    case glass

    public var displayName: String { rawValue.capitalized }
}

// MARK: - SHButton

public struct SHButton: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let icon: String?
    private let iconPlacement: IconPlacement
    private let variant: SHButtonVariant
    private let size: SHControlSize
    private let isLoading: Bool
    private let fillsWidth: Bool
    private let action: () -> Void

    public enum IconPlacement: Sendable { case leading, trailing }

    public init(
        _ title: String,
        icon: String? = nil,
        iconPlacement: IconPlacement = .leading,
        variant: SHButtonVariant = .primary,
        size: SHControlSize = .medium,
        isLoading: Bool = false,
        fillsWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.iconPlacement = iconPlacement
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.fillsWidth = fillsWidth
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            label
        }
        .buttonStyle(.shPressable)
        // 로딩 중에도 `.disabled`를 쓴다. 접근성 트레잇이 함께 전달되어야
        // VoiceOver 사용자가 "지금 누를 수 없음"을 알 수 있다.
        .disabled(isLoading)
        .shDisabledAppearance()
        .accessibilityLabel(Text(title))
        .accessibilityValue(isLoading ? Text("로딩 중") : Text(""))
    }

    private var label: some View {
        HStack(spacing: SH.spacing.xs) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(foreground)
                    .scaleEffect(0.8)
            } else {
                if icon != nil, iconPlacement == .leading { iconView }
                Text(title)
                    .shFont(size.font)
                    .lineLimit(1)
                if icon != nil, iconPlacement == .trailing { iconView }
            }
        }
        .frame(maxWidth: fillsWidth ? .infinity : nil)
        .frame(height: size.height)
        .padding(.horizontal, size.horizontalPadding)
        .foregroundStyle(foreground)
        .background(background)
        .clipShape(theme.shape.button.shape)
        .overlay(border)
        .shShadow(shadow)
        .contentShape(theme.shape.button.shape)
    }

    @ViewBuilder
    private var iconView: some View {
        if let icon {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .accessibilityHidden(true)
        }
    }

    // MARK: Appearance

    private var foreground: Color {
        switch variant {
        case .primary:     return theme.colors.onPrimary
        case .secondary:   return theme.colors.onPrimaryContainer
        case .outlined,
             .ghost:       return theme.colors.primaryText
        case .destructive: return theme.colors.onError
        case .glass:       return theme.colors.textPrimary
        }
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .primary:     theme.colors.primary
        case .secondary:   theme.colors.primaryContainer
        case .outlined,
             .ghost:       Color.clear
        case .destructive: theme.colors.error
        case .glass:       theme.shape.button.shape.fill(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    private var border: some View {
        switch variant {
        case .outlined:
            theme.shape.button.shape
                .stroke(theme.colors.primaryText, lineWidth: SH.size.borderEmphasis)
        case .glass:
            theme.shape.button.shape
                .stroke(theme.colors.glassBorder, lineWidth: SH.size.border)
        default:
            EmptyView()
        }
    }

    private var shadow: SHShadowToken {
        variant == .primary ? theme.elevation.raised : .none
    }
}

// MARK: - SHIconButton

public struct SHIconButton: View {
    @Environment(\.shTheme) private var theme

    private let icon: String
    private let accessibilityLabel: String
    private let variant: SHButtonVariant
    private let size: SHControlSize
    private let action: () -> Void

    /// - Parameter accessibilityLabel: 아이콘만 있는 버튼은 VoiceOver가
    ///   읽을 텍스트가 없다. 그래서 선택 항목이 아니라 **필수 인자**다.
    public init(
        icon: String,
        accessibilityLabel: String,
        variant: SHButtonVariant = .ghost,
        size: SHControlSize = .medium,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.accessibilityLabel = accessibilityLabel
        self.variant = variant
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundStyle(foreground)
                .frame(width: size.height, height: size.height)
                .background(background)
                .clipShape(Circle())
                .overlay(border)
                .shMinTapTarget()
        }
        .buttonStyle(.shPressable)
        .shDisabledAppearance()
        .accessibilityLabel(Text(accessibilityLabel))
    }

    private var foreground: Color {
        switch variant {
        case .primary:     return theme.colors.onPrimary
        case .secondary:   return theme.colors.onPrimaryContainer
        case .outlined,
             .ghost:       return theme.colors.primaryText
        case .destructive: return theme.colors.onError
        case .glass:       return theme.colors.textPrimary
        }
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .primary:     theme.colors.primary
        case .secondary:   theme.colors.primaryContainer
        case .outlined,
             .ghost:       Color.clear
        case .destructive: theme.colors.error
        case .glass:       Circle().fill(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    private var border: some View {
        switch variant {
        case .outlined:
            Circle().stroke(theme.colors.primaryText, lineWidth: SH.size.borderEmphasis)
        case .glass:
            Circle().stroke(theme.colors.glassBorder, lineWidth: SH.size.border)
        default:
            EmptyView()
        }
    }
}

// MARK: - Preview

#Preview("Variants") {
    ScrollView {
        VStack(spacing: SH.spacing.md) {
            ForEach(SHButtonVariant.allCases, id: \.self) { variant in
                SHButton(variant.displayName, icon: "sparkles", variant: variant, fillsWidth: true) {}
            }
            SHButton("비활성", variant: .primary, fillsWidth: true) {}
                .disabled(true)
            SHButton("로딩", variant: .primary, isLoading: true, fillsWidth: true) {}
        }
        .padding()
    }
    .background(SHThemeBackground())
    .shTheme(.lavender)
}

#Preview("All Themes · Primary") {
    ScrollView {
        VStack(spacing: SH.spacing.md) {
            ForEach(SHTheme.presets, id: \.name) { preset in
                VStack(spacing: SH.spacing.xs) {
                    SHButton(preset.name, variant: .primary, fillsWidth: true) {}
                    SHButton(preset.name, variant: .secondary, fillsWidth: true) {}
                }
                .shTheme(preset.theme)
            }
        }
        .padding()
    }
}
