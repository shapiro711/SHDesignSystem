import SwiftUI

// MARK: - SHSegmentedControl
/// 세그먼트 선택. 선택 표시가 `matchedGeometryEffect`로 미끄러진다.
public struct SHSegmentedControl<Item: Hashable>: View {
    @Environment(\.shTheme) private var theme
    @Namespace private var namespace

    @Binding private var selection: Item

    private let items: [Item]
    private let title: (Item) -> String

    public init(_ items: [Item], selection: Binding<Item>, title: @escaping (Item) -> String) {
        self.items = items
        self._selection = selection
        self.title = title
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.self) { item in
                segment(item)
            }
        }
        .padding(SH.spacing.xxs)
        .background(theme.colors.surfaceSunken)
        .clipShape(theme.shape.chip.shape)
        .accessibilityElement(children: .contain)
    }

    private func segment(_ item: Item) -> some View {
        let isSelected = selection == item

        return Button {
            selection = item
            SHHaptics.selection()
        } label: {
            SHText(
                title(item),
                \.labelLarge,
                role: isSelected ? .custom(theme.colors.onPrimary) : .secondary,
                alignment: .center
            )
            .lineLimit(1)
            .frame(maxWidth: .infinity)
            .padding(.vertical, SH.spacing.xs)
            .background {
                if isSelected {
                    theme.shape.chip.shape
                        .fill(theme.colors.primary)
                        .matchedGeometryEffect(id: "sh.segment", in: namespace)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(theme.motion.standard, value: selection)
        .accessibilityLabel(Text(title(item)))
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

public extension SHSegmentedControl where Item == String {
    init(_ items: [String], selection: Binding<String>) {
        self.init(items, selection: selection, title: { $0 })
    }
}

// MARK: - SHStepper

public struct SHStepper: View {
    @Environment(\.shTheme) private var theme

    @Binding private var value: Int

    private let range: ClosedRange<Int>
    private let step: Int
    private let label: String?

    public init(
        value: Binding<Int>,
        in range: ClosedRange<Int> = 0...99,
        step: Int = 1,
        label: String? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
    }

    public var body: some View {
        HStack(spacing: SH.spacing.md) {
            if let label {
                SHText(label, \.bodyLarge)
                Spacer()
            }

            HStack(spacing: 0) {
                button(systemName: "minus", enabled: value > range.lowerBound) {
                    value = max(value - step, range.lowerBound)
                }

                SHText("\(value)", \.titleSmall, alignment: .center)
                    .frame(minWidth: 44)
                    .contentTransition(.numericText())

                button(systemName: "plus", enabled: value < range.upperBound) {
                    value = min(value + step, range.upperBound)
                }
            }
            .background(theme.colors.surfaceSunken)
            .clipShape(theme.shape.chip.shape)
        }
        .animation(theme.motion.quick, value: value)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(label ?? "값"))
        .accessibilityValue(Text("\(value)"))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: value = min(value + step, range.upperBound)
            case .decrement: value = max(value - step, range.lowerBound)
            @unknown default: break
            }
        }
    }

    private func button(systemName: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
            SHHaptics.selection()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: SH.size.iconSM, weight: .bold))
                .foregroundStyle(enabled ? theme.colors.primaryText : theme.colors.textDisabled)
                .frame(width: SH.size.minTapTarget, height: SH.size.minTapTarget)
                .contentShape(Rectangle())
        }
        .buttonStyle(.shPressable(haptic: nil))
        .disabled(!enabled)
        .accessibilityHidden(true)
    }
}

// MARK: - SHSlider

public struct SHSlider: View {
    @Environment(\.shTheme) private var theme

    @Binding private var value: Double

    private let range: ClosedRange<Double>
    private let step: Double?
    private let label: String?
    private let valueFormat: (Double) -> String

    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double? = nil,
        label: String? = nil,
        valueFormat: @escaping (Double) -> String = { String(format: "%.0f", $0) }
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
        self.valueFormat = valueFormat
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SH.spacing.xs) {
            if let label {
                HStack {
                    SHText(label, \.labelMedium, role: .secondary)
                    Spacer()
                    SHText(valueFormat(value), \.labelMedium, role: .brand)
                }
            }

            slider
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(label ?? "값"))
        .accessibilityValue(Text(valueFormat(value)))
    }

    @ViewBuilder
    private var slider: some View {
        if let step {
            Slider(value: $value, in: range, step: step)
                .tint(theme.colors.primary)
        } else {
            Slider(value: $value, in: range)
                .tint(theme.colors.primary)
        }
    }
}

// MARK: - Preview

#Preview("Controls") {
    struct Demo: View {
        @State private var segment = "주간"
        @State private var count = 2
        @State private var amount = 0.4

        var body: some View {
            VStack(spacing: SH.spacing.xl) {
                SHSegmentedControl(["일간", "주간", "월간"], selection: $segment)
                SHStepper(value: $count, in: 0...10, label: "인원")
                SHSlider(value: $amount, label: "밝기") { "\(Int($0 * 100))%" }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    return Demo()
        .background(SHThemeBackground())
        .shTheme(.sky)
}
