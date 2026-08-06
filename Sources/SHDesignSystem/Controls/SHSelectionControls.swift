import SwiftUI

// MARK: - SHToggle

public struct SHToggle: View {
    @Environment(\.shTheme) private var theme

    @Binding private var isOn: Bool
    private let title: String?
    private let subtitle: String?

    public init(_ title: String? = nil, subtitle: String? = nil, isOn: Binding<Bool>) {
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            if let title {
                VStack(alignment: .leading, spacing: SH.spacing.xxxs) {
                    SHText(title, \.bodyLarge)
                    if let subtitle {
                        SHText(subtitle, \.bodySmall, role: .secondary)
                    }
                }
            }
        }
        .labelsHidden(title == nil)
        .tint(theme.colors.primary)
        .onChange(of: isOn) { _, _ in SHHaptics.selection() }
    }
}

private extension View {
    @ViewBuilder
    func labelsHidden(_ hidden: Bool) -> some View {
        if hidden { self.labelsHidden() } else { self }
    }
}

// MARK: - SHCheckbox

public struct SHCheckbox: View {
    @Environment(\.shTheme) private var theme

    @Binding private var isChecked: Bool
    private let title: String?
    private let isIndeterminate: Bool

    public init(_ title: String? = nil, isChecked: Binding<Bool>, isIndeterminate: Bool = false) {
        self.title = title
        self._isChecked = isChecked
        self.isIndeterminate = isIndeterminate
    }

    public var body: some View {
        Button {
            isChecked.toggle()
            SHHaptics.selection()
        } label: {
            HStack(spacing: SH.spacing.sm) {
                box
                if let title {
                    SHText(title, \.bodyLarge)
                }
            }
            .shMinTapTarget()
        }
        .buttonStyle(.shPressable(haptic: nil))
        .accessibilityLabel(Text(title ?? "선택"))
        .accessibilityAddTraits(isChecked ? [.isSelected] : [])
        .accessibilityValue(Text(isChecked ? "선택됨" : "선택 안 됨"))
    }

    private var box: some View {
        RoundedRectangle(cornerRadius: SH.radius.sm, style: .continuous)
            .fill(isChecked || isIndeterminate ? theme.colors.primary : Color.clear)
            .overlay {
                RoundedRectangle(cornerRadius: SH.radius.sm, style: .continuous)
                    .stroke(
                        isChecked || isIndeterminate ? Color.clear : theme.colors.borderStrong,
                        lineWidth: SH.size.borderEmphasis
                    )
            }
            .overlay {
                Image(systemName: isIndeterminate ? "minus" : "checkmark")
                    .font(.system(size: SH.size.iconXS, weight: .bold))
                    .foregroundStyle(theme.colors.onPrimary)
                    .opacity(isChecked || isIndeterminate ? 1 : 0)
            }
            .frame(width: 24, height: 24)
            .animation(theme.motion.quick, value: isChecked)
    }
}

// MARK: - SHRadioGroup

public struct SHRadioGroup<Item: Hashable>: View {
    @Environment(\.shTheme) private var theme

    @Binding private var selection: Item?

    private let items: [Item]
    private let title: (Item) -> String
    private let axis: Axis

    public init(
        _ items: [Item],
        selection: Binding<Item?>,
        axis: Axis = .vertical,
        title: @escaping (Item) -> String
    ) {
        self.items = items
        self._selection = selection
        self.axis = axis
        self.title = title
    }

    public var body: some View {
        Group {
            if axis == .vertical {
                VStack(alignment: .leading, spacing: SH.spacing.xs) { rows }
            } else {
                HStack(spacing: SH.spacing.md) { rows }
            }
        }
        // 그룹 전체가 하나의 라디오 그룹임을 VoiceOver에 알린다.
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var rows: some View {
        ForEach(items, id: \.self) { item in
            Button {
                selection = item
                SHHaptics.selection()
            } label: {
                HStack(spacing: SH.spacing.sm) {
                    dot(isSelected: selection == item)
                    SHText(title(item), \.bodyLarge)
                }
                .shMinTapTarget()
            }
            .buttonStyle(.shPressable(haptic: nil))
            .accessibilityLabel(Text(title(item)))
            .accessibilityAddTraits(selection == item ? [.isSelected] : [])
        }
    }

    private func dot(isSelected: Bool) -> some View {
        Circle()
            .stroke(
                isSelected ? theme.colors.primary : theme.colors.borderStrong,
                lineWidth: SH.size.borderEmphasis
            )
            .overlay {
                Circle()
                    .fill(theme.colors.primary)
                    .padding(5)
                    .opacity(isSelected ? 1 : 0)
            }
            .frame(width: 24, height: 24)
            .animation(theme.motion.quick, value: isSelected)
    }
}

public extension SHRadioGroup where Item == String {
    init(_ items: [String], selection: Binding<String?>, axis: Axis = .vertical) {
        self.init(items, selection: selection, axis: axis, title: { $0 })
    }
}

// MARK: - Preview

#Preview("Selection Controls") {
    struct Demo: View {
        @State private var toggle = true
        @State private var check = false
        @State private var radio: String? = "매일"

        var body: some View {
            VStack(alignment: .leading, spacing: SH.spacing.lg) {
                SHToggle("알림 받기", subtitle: "새 소식을 알려드려요", isOn: $toggle)
                SHDivider()
                SHCheckbox("이용약관에 동의합니다", isChecked: $check)
                SHCheckbox("부분 선택", isChecked: .constant(false), isIndeterminate: true)
                SHDivider()
                SHRadioGroup(["매일", "매주", "매월"], selection: $radio)
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    return Demo()
        .background(SHThemeBackground())
        .shTheme(.lavender)
}
