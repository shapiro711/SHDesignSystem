import SwiftUI

// MARK: - SHBarChartEntry

/// 막대 하나.
///
/// `value`가 `nil`이면 "그날은 데이터가 없다"는 뜻이고, 막대는 빈 슬롯으로 자리를 지킨다.
/// 없는 날을 건너뛰면 가로축의 시간 간격이 왜곡돼 패턴을 잘못 읽게 된다.
public struct SHBarChartEntry<ID: Hashable & Sendable>: Identifiable, Equatable, Sendable {
    /// 선택 판정과 스크롤 대상에 쓰는 식별값 (날짜, 요일, 카테고리 등)
    public let id: ID
    /// 가로축·접근성 문구에 쓰는 표시 이름
    public let label: String
    /// 막대 값. `nil`이면 데이터 없는 구간
    public let value: Double?

    public init(id: ID, label: String, value: Double?) {
        self.id = id
        self.label = label
        self.value = value
    }
}

public extension SHBarChartEntry where ID == String {
    /// 라벨을 그대로 식별자로 쓰는 축약형
    init(label: String, value: Double?) {
        self.init(id: label, label: label, value: value)
    }
}

// MARK: - SHBarChart

/// 목표선을 가진 막대 그래프.
///
/// 기록형 앱(수면·복약·물 마시기·운동)이 공통으로 필요로 하는 최소 그래프다.
/// Swift Charts를 쓰지 않아 iOS 16 미만 대응이나 추가 의존성이 필요 없고,
/// 색·모양·모션이 전부 테마에서 나온다.
///
/// - 목표 미달 막대는 다른 색으로 그린다 (색맹 대응을 위해 접근성 문구도 값을 읽어 준다)
/// - 데이터 없는 구간은 빈 슬롯으로 자리를 유지한다
/// - 막대를 탭하면 `onSelect`가 불린다
///
/// ```swift
/// SHBarChart(
///     entries: days.map { SHBarChartEntry(id: $0.date, label: $0.title, value: $0.hours) },
///     goal: 7.5,
///     selection: highlightedID,
///     accessibilityValue: { "\($0.label), \($0.value.map { "\($0)시간" } ?? "기록 없음")" },
///     onSelect: { store.send(.barTapped($0)) }
/// )
/// ```
public struct SHBarChart<ID: Hashable & Sendable>: View {
    @Environment(\.shTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let entries: [SHBarChartEntry<ID>]
    private let goal: Double?
    private let height: CGFloat
    private let selection: ID?
    private let leadingLabel: String?
    private let trailingLabel: String?
    private let accessibilityValue: (SHBarChartEntry<ID>) -> String
    private let onSelect: ((SHBarChartEntry<ID>) -> Void)?

    public init(
        entries: [SHBarChartEntry<ID>],
        goal: Double? = nil,
        height: CGFloat = 132,
        selection: ID? = nil,
        leadingLabel: String? = nil,
        trailingLabel: String? = nil,
        accessibilityValue: @escaping (SHBarChartEntry<ID>) -> String,
        onSelect: ((SHBarChartEntry<ID>) -> Void)? = nil
    ) {
        self.entries = entries
        self.goal = goal
        self.height = height
        self.selection = selection
        self.leadingLabel = leadingLabel
        self.trailingLabel = trailingLabel
        self.accessibilityValue = accessibilityValue
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SH.spacing.xs) {
            ZStack(alignment: .bottom) {
                goalLine
                bars
            }
            .frame(height: height)

            if leadingLabel != nil || trailingLabel != nil {
                HStack {
                    SHText(leadingLabel ?? "", \.captionSmall, role: .tertiary)
                    Spacer(minLength: 0)
                    SHText(trailingLabel ?? "", \.captionSmall, role: .tertiary)
                }
            }
        }
        .accessibilityElement(children: .contain)
    }

    // MARK: - 조각들

    private var bars: some View {
        HStack(alignment: .bottom, spacing: SH.spacing.xxxs) {
            ForEach(entries) { entry in
                bar(for: entry)
            }
        }
    }

    private func bar(for entry: SHBarChartEntry<ID>) -> some View {
        let isSelected = selection == entry.id

        return RoundedRectangle(cornerRadius: SH.radius.xs, style: .continuous)
            .fill(fill(for: entry, isSelected: isSelected))
            .frame(height: barHeight(for: entry))
            .frame(maxWidth: .infinity, alignment: .bottom)
            .overlay(alignment: .bottom) {
                if isSelected {
                    RoundedRectangle(cornerRadius: SH.radius.xs, style: .continuous)
                        .stroke(theme.colors.primaryText, lineWidth: SH.size.borderEmphasis)
                        .frame(height: barHeight(for: entry))
                }
            }
            .animation(reduceMotion ? nil : theme.motion.quick, value: entry.value)
            .contentShape(.rect)
            .onTapGesture {
                guard let onSelect else { return }
                SHHaptics.selection()
                onSelect(entry)
            }
            .accessibilityElement()
            .accessibilityLabel(Text(accessibilityValue(entry)))
            .accessibilityAddTraits(traits(isSelected: isSelected))
    }

    private func traits(isSelected: Bool) -> AccessibilityTraits {
        var traits: AccessibilityTraits = []
        if onSelect != nil { traits.insert(.isButton) }
        if isSelected { traits.insert(.isSelected) }
        return traits
    }

    @ViewBuilder
    private var goalLine: some View {
        if let goal, let maximum, maximum > 0 {
            let ratio = min(1, goal / maximum)
            VStack(spacing: 0) {
                Spacer(minLength: 0).frame(height: height * (1 - ratio))
                Rectangle()
                    .fill(theme.colors.primaryText.opacity(0.35))
                    .frame(height: SH.size.divider)
                Spacer(minLength: 0).frame(height: height * ratio)
            }
            // 목표선은 장식이다. 값은 각 막대의 접근성 문구가 읽어 준다.
            .accessibilityHidden(true)
        }
    }

    private func fill(for entry: SHBarChartEntry<ID>, isSelected: Bool) -> Color {
        guard let value = entry.value else {
            return theme.colors.surfaceSunken
        }
        if let goal, value < goal {
            // 목표 미달 — 채도를 낮춰 구분한다
            return theme.colors.textTertiary.opacity(isSelected ? 0.9 : 0.55)
        }
        return isSelected ? theme.colors.primary : theme.colors.primaryContainer
    }

    private func barHeight(for entry: SHBarChartEntry<ID>) -> CGFloat {
        guard let value = entry.value, let maximum, maximum > 0 else {
            return emptySlotHeight
        }
        return max(emptySlotHeight, height * CGFloat(value / maximum))
    }

    /// 데이터 없는 날도 눈에 보이게 남기는 최소 높이
    private var emptySlotHeight: CGFloat { 4 }

    /// 막대 높이 기준. 목표선이 잘리지 않도록 목표값도 후보에 넣는다.
    private var maximum: Double? {
        (entries.compactMap(\.value) + [goal].compactMap { $0 }).max()
    }
}

// MARK: - Preview

#Preview("SHBarChart") {
    struct Demo: View {
        @State private var selection: String?

        private var entries: [SHBarChartEntry<String>] {
            let values: [Double?] = [6.2, 7.8, nil, 5.1, 8.0, 7.4, 4.5, 7.6, nil, 6.9, 8.2, 5.5, 7.5, 6.1]
            return values.enumerated().map { index, value in
                SHBarChartEntry(label: "\(index + 1)", value: value)
            }
        }

        var body: some View {
            VStack(spacing: SH.spacing.lg) {
                SHCard {
                    SHBarChart(
                        entries: entries,
                        goal: 7.5,
                        selection: selection,
                        leadingLabel: "7/24",
                        trailingLabel: "8/6",
                        accessibilityValue: { entry in
                            guard let value = entry.value else { return "\(entry.label)일, 기록 없음" }
                            return "\(entry.label)일, \(value)시간"
                        },
                        onSelect: { selection = $0.id }
                    )
                }

                SHCard {
                    SHBarChart(
                        entries: entries,
                        accessibilityValue: { $0.label }
                    )
                }
            }
            .padding()
        }
    }
    return Demo()
        .background(SHThemeBackground())
        .shTheme(.mint)
}
