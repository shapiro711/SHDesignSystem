import SwiftUI

// MARK: - Chip Style
public enum SHChipStyle: String, CaseIterable, Sendable {
    case filled
    case outlined
    case glass

    public var displayName: String {
        switch self {
        case .filled: return "Filled"
        case .outlined: return "Outlined"
        case .glass: return "Glass"
        }
    }
}

// MARK: - Chip Size
public enum SHChipSize: String, CaseIterable, Sendable {
    case small
    case medium
    case large

    var height: CGFloat {
        switch self {
        case .small: return 28
        case .medium: return 36
        case .large: return 44
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return SH.spacing.sm
        case .medium: return SH.spacing.md
        case .large: return SH.spacing.lg
        }
    }

    var font: Font {
        switch self {
        case .small: return SH.typography.labelSmall
        case .medium: return SH.typography.labelMedium
        case .large: return SH.typography.labelLarge
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 14
        case .large: return 16
        }
    }
}

// MARK: - SHChip
public struct SHChip: View {
    @Environment(\.shTheme) private var theme

    private let title: String
    private let icon: String?
    private let style: SHChipStyle
    private let size: SHChipSize
    private let isSelected: Bool
    private let isDismissible: Bool
    private let action: (() -> Void)?
    private let onDismiss: (() -> Void)?

    public init(
        _ title: String,
        icon: String? = nil,
        style: SHChipStyle = .filled,
        size: SHChipSize = .medium,
        isSelected: Bool = false,
        isDismissible: Bool = false,
        action: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.isSelected = isSelected
        self.isDismissible = isDismissible
        self.action = action
        self.onDismiss = onDismiss
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
        HStack(spacing: SH.spacing.xs) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: .medium))
            }

            Text(title)
                .font(size.font)

            if isDismissible {
                Button {
                    onDismiss?()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: size.iconSize - 2, weight: .medium))
                }
            }
        }
        .foregroundStyle(foregroundColor)
        .padding(.horizontal, size.horizontalPadding)
        .frame(height: size.height)
        .background(backgroundView)
        .clipShape(Capsule())
        .overlay(overlayView)
    }

    private var foregroundColor: Color {
        switch style {
        case .filled:
            return isSelected ? SH.colors.textOnColor : SH.colors.textPrimary
        case .outlined:
            return isSelected ? theme.primaryColor : SH.colors.textPrimary
        case .glass:
            return SH.colors.textPrimary
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .filled:
            isSelected ? theme.primaryColor : theme.primaryColor.opacity(0.15)
        case .outlined:
            isSelected ? theme.primaryColor.opacity(0.1) : Color.clear
        case .glass:
            Capsule().fill(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        switch style {
        case .filled:
            EmptyView()
        case .outlined:
            Capsule()
                .stroke(isSelected ? theme.primaryColor : SH.colors.border, lineWidth: 1)
        case .glass:
            Capsule()
                .stroke(SH.colors.glassBorder, lineWidth: 1)
        }
    }
}

// MARK: - Chip Group
public struct SHChipGroup: View {
    private let chips: [String]
    @Binding private var selectedChips: Set<String>
    private let style: SHChipStyle
    private let size: SHChipSize
    private let allowsMultipleSelection: Bool

    public init(
        chips: [String],
        selectedChips: Binding<Set<String>>,
        style: SHChipStyle = .filled,
        size: SHChipSize = .medium,
        allowsMultipleSelection: Bool = true
    ) {
        self.chips = chips
        self._selectedChips = selectedChips
        self.style = style
        self.size = size
        self.allowsMultipleSelection = allowsMultipleSelection
    }

    public var body: some View {
        FlowLayout(spacing: SH.spacing.xs) {
            ForEach(chips, id: \.self) { chip in
                SHChip(
                    chip,
                    style: style,
                    size: size,
                    isSelected: selectedChips.contains(chip)
                ) {
                    if allowsMultipleSelection {
                        if selectedChips.contains(chip) {
                            selectedChips.remove(chip)
                        } else {
                            selectedChips.insert(chip)
                        }
                    } else {
                        selectedChips = [chip]
                    }
                }
            }
        }
    }
}

// MARK: - Flow Layout
public struct FlowLayout: Layout {
    var spacing: CGFloat

    public init(spacing: CGFloat = SH.spacing.xs) {
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )

        for (index, subview) in subviews.enumerated() {
            subview.place(
                at: CGPoint(
                    x: bounds.minX + result.positions[index].x,
                    y: bounds.minY + result.positions[index].y
                ),
                proposal: ProposedViewSize(result.sizes[index])
            )
        }
    }

    struct FlowResult {
        var sizes: [CGSize] = []
        var positions: [CGPoint] = []
        var size: CGSize = .zero

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            var maxX: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                sizes.append(size)

                if currentX + size.width > maxWidth, currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
                maxX = max(maxX, currentX)
            }

            size = CGSize(width: maxX - spacing, height: currentY + lineHeight)
        }
    }
}

// MARK: - Preview
#Preview("SHChip Styles") {
    VStack(spacing: 24) {
        ForEach(SHChipStyle.allCases, id: \.self) { style in
            VStack(alignment: .leading, spacing: 8) {
                Text(style.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack {
                    SHChip("기본", style: style)
                    SHChip("선택됨", style: style, isSelected: true)
                    SHChip("아이콘", icon: "star.fill", style: style)
                }
            }
        }
    }
    .padding()
    .shTheme(.pastelLavender)
}

#Preview("SHChipGroup") {
    struct PreviewWrapper: View {
        @State private var selected: Set<String> = ["Swift"]

        var body: some View {
            SHChipGroup(
                chips: ["Swift", "SwiftUI", "UIKit", "Combine", "Core Data"],
                selectedChips: $selected
            )
            .padding()
            .shTheme(.pastelMint)
        }
    }
    return PreviewWrapper()
}
