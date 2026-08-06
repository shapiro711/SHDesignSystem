import SwiftUI

// MARK: - Chip Variant

public enum SHChipVariant: String, Sendable, CaseIterable {
    case tinted     // 파스텔 컨테이너
    case outlined
    case glass
    case status     // 상태색

    public var displayName: String { rawValue.capitalized }
}

public enum SHChipSize: String, Sendable, CaseIterable {
    case small, medium

    var height: CGFloat {
        switch self {
        case .small: return 28
        case .medium: return 34
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return SH.spacing.xs
        case .medium: return SH.spacing.sm
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return SH.size.iconXS
        case .medium: return SH.size.iconSM
        }
    }

    var font: KeyPath<SHTypographyScheme, SHFontToken> {
        switch self {
        case .small: return \.labelSmall
        case .medium: return \.labelMedium
        }
    }
}

// MARK: - SHChip

public struct SHChip: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let icon: String?
    private let variant: SHChipVariant
    private let size: SHChipSize
    private let status: SHStatusKind
    private let isSelected: Bool
    private let action: (() -> Void)?
    private let onRemove: (() -> Void)?

    public init(
        _ title: String,
        icon: String? = nil,
        variant: SHChipVariant = .tinted,
        size: SHChipSize = .medium,
        status: SHStatusKind = .info,
        isSelected: Bool = false,
        onRemove: (() -> Void)? = nil,
        // trailing closure가 `action`에 붙도록 마지막에 둔다.
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.variant = variant
        self.size = size
        self.status = status
        self.isSelected = isSelected
        self.action = action
        self.onRemove = onRemove
    }

    public var body: some View {
        if let action {
            Button(action: action) { content }
                .buttonStyle(.shPressable(haptic: nil))
                .accessibilityLabel(Text(title))
                .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        } else {
            content
        }
    }

    private var content: some View {
        HStack(spacing: SH.spacing.xxs) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: .semibold))
                    .accessibilityHidden(true)
            }

            SHText(title, size.font, role: .custom(foreground))

            if let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .font(.system(size: size.iconSize - 3, weight: .bold))
                }
                .buttonStyle(.shPressable(haptic: nil))
                .accessibilityLabel(Text("\(title) 삭제"))
            }
        }
        .foregroundStyle(foreground)
        .padding(.horizontal, size.horizontalPadding)
        .frame(height: size.height)
        .background(background)
        .clipShape(theme.shape.chip.shape)
        .overlay(border)
        .animation(theme.motion.quick, value: isSelected)
    }

    // MARK: Appearance

    private var foreground: Color {
        switch variant {
        case .tinted:
            return isSelected ? theme.colors.onPrimary : theme.colors.onPrimaryContainer
        case .outlined:
            return isSelected ? theme.colors.onPrimary : theme.colors.textSecondary
        case .glass:
            return theme.colors.textPrimary
        case .status:
            return theme.colors.onContainer(for: status)
        }
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .tinted:
            isSelected ? theme.colors.primary : theme.colors.primaryContainer
        case .outlined:
            isSelected ? theme.colors.primary : Color.clear
        case .glass:
            theme.shape.chip.shape.fill(.ultraThinMaterial)
        case .status:
            theme.colors.container(for: status)
        }
    }

    @ViewBuilder
    private var border: some View {
        switch variant {
        case .outlined:
            theme.shape.chip.shape.stroke(
                isSelected ? Color.clear : theme.colors.border,
                lineWidth: SH.size.border
            )
        case .glass:
            theme.shape.chip.shape.stroke(theme.colors.glassBorder, lineWidth: SH.size.border)
        case .tinted, .status:
            EmptyView()
        }
    }
}

// MARK: - SHChipGroup

/// 선택 가능한 칩 묶음. 필터 UI의 기본 단위.
public struct SHChipGroup<Item: Hashable>: View {
    @Binding private var selection: Set<Item>

    private let items: [Item]
    private let title: (Item) -> String
    private let icon: (Item) -> String?
    private let variant: SHChipVariant
    private let size: SHChipSize
    private let allowsMultipleSelection: Bool

    public init(
        _ items: [Item],
        selection: Binding<Set<Item>>,
        variant: SHChipVariant = .tinted,
        size: SHChipSize = .medium,
        allowsMultipleSelection: Bool = true,
        icon: @escaping (Item) -> String? = { _ in nil },
        title: @escaping (Item) -> String
    ) {
        self.items = items
        self._selection = selection
        self.variant = variant
        self.size = size
        self.allowsMultipleSelection = allowsMultipleSelection
        self.icon = icon
        self.title = title
    }

    public var body: some View {
        // iOS 16+ 네이티브 흐름 레이아웃. 직접 구현한 wrap 로직보다
        // Dynamic Type 확대 시 훨씬 안정적이다.
        SHFlowLayout(spacing: SH.spacing.xs, lineSpacing: SH.spacing.xs) {
            ForEach(items, id: \.self) { item in
                SHChip(
                    title(item),
                    icon: icon(item),
                    variant: variant,
                    size: size,
                    isSelected: selection.contains(item)
                ) {
                    toggle(item)
                }
            }
        }
    }

    private func toggle(_ item: Item) {
        if allowsMultipleSelection {
            if selection.contains(item) { selection.remove(item) } else { selection.insert(item) }
        } else {
            selection = selection.contains(item) ? [] : [item]
        }
    }
}

public extension SHChipGroup where Item == String {
    init(
        _ items: [String],
        selection: Binding<Set<String>>,
        variant: SHChipVariant = .tinted,
        size: SHChipSize = .medium,
        allowsMultipleSelection: Bool = true
    ) {
        self.init(
            items,
            selection: selection,
            variant: variant,
            size: size,
            allowsMultipleSelection: allowsMultipleSelection,
            icon: { _ in nil },
            title: { $0 }
        )
    }
}

// MARK: - Preview

#Preview("Chips") {
    VStack(alignment: .leading, spacing: SH.spacing.lg) {
        ForEach(SHChipVariant.allCases, id: \.self) { variant in
            HStack {
                SHChip(variant.displayName, icon: "tag.fill", variant: variant)
                SHChip("선택됨", variant: variant, isSelected: true, action: {})
                SHChip("삭제", variant: variant, onRemove: {})
            }
        }

        SHChipGroup(["전체", "진행중", "완료", "보관됨", "즐겨찾기"], selection: .constant(["진행중"]))
    }
    .padding()
    .background(SHThemeBackground())
    .shTheme(.sky)
}
