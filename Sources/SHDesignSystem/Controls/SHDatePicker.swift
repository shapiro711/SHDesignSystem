import SwiftUI

// MARK: - SHDatePicker

/// 날짜·시간 선택.
///
/// SwiftUI `DatePicker`를 감싸되 라벨 타이포와 브랜드 tint를 SH 규약에 맞춘다.
/// 시스템 피커를 그대로 쓰면 라벨이 `.body`로 굳고 accent가 iOS 기본 파랑이 되어
/// 파스텔 화면에서 혼자 튄다.
///
/// ```swift
/// SHDatePicker("기상 시각", selection: $wakeTime, components: .time)
/// SHDatePicker("취침", selection: $bedAt, components: .dateAndTime)
/// SHDatePicker("기상 시각", selection: $wakeTime, components: .time, style: .wheel)
/// ```
public struct SHDatePicker: View {
    @Environment(\.shTheme) private var theme

    /// 무엇을 고를지
    public enum Components: Sendable {
        /// 시·분만
        case time
        /// 날짜만
        case date
        /// 날짜 + 시·분
        case dateAndTime

        var displayed: DatePickerComponents {
            switch self {
            case .time: [.hourAndMinute]
            case .date: [.date]
            case .dateAndTime: [.date, .hourAndMinute]
            }
        }
    }

    /// 어떻게 보일지
    public enum Style: Sendable {
        /// 행에 얹는 축약형. 설정 화면 기본값
        case compact
        /// 휠. 온보딩처럼 이 선택이 화면의 주인공일 때
        case wheel
        /// 달력. 날짜를 훑어야 할 때
        case graphical
    }

    @Binding private var selection: Date

    private let title: String
    private let subtitle: String?
    private let components: Components
    private let style: Style
    private let range: ClosedRange<Date>?

    public init(
        _ title: String,
        selection: Binding<Date>,
        subtitle: String? = nil,
        components: Components = .dateAndTime,
        style: Style = .compact,
        in range: ClosedRange<Date>? = nil
    ) {
        self.title = title
        self._selection = selection
        self.subtitle = subtitle
        self.components = components
        self.style = style
        self.range = range
    }

    public var body: some View {
        Group {
            switch style {
            case .compact:
                compactRow
            case .wheel:
                stacked { picker.datePickerStyle(.wheel).labelsHidden() }
            case .graphical:
                stacked { picker.datePickerStyle(.graphical).labelsHidden() }
            }
        }
        .onChange(of: selection) { _, _ in SHHaptics.selection() }
    }

    // MARK: - 조각들

    private var compactRow: some View {
        HStack(spacing: SH.spacing.sm) {
            label
            Spacer(minLength: SH.spacing.xs)
            picker
                .datePickerStyle(.compact)
                .labelsHidden()
        }
        .shMinTapTarget()
    }

    /// 휠·달력은 라벨을 위에 두고 피커가 폭을 다 쓰게 한다.
    private func stacked(@ViewBuilder _ content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: SH.spacing.xs) {
            label
            content()
                .frame(maxWidth: .infinity)
        }
    }

    private var label: some View {
        VStack(alignment: .leading, spacing: SH.spacing.xxxs) {
            SHText(title, \.bodyLarge)
            if let subtitle {
                SHText(subtitle, \.bodySmall, role: .secondary)
            }
        }
    }

    @ViewBuilder
    private var picker: some View {
        if let range {
            DatePicker(
                title,
                selection: $selection,
                in: range,
                displayedComponents: components.displayed
            )
        } else {
            DatePicker(
                title,
                selection: $selection,
                displayedComponents: components.displayed
            )
        }
    }
}

// MARK: - Preview

#Preview("SHDatePicker") {
    struct Demo: View {
        @State private var wake = Date()
        @State private var bed = Date()

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: SH.spacing.lg) {
                    SHText("compact", \.labelMedium, role: .secondary)
                    SHDatePicker("기상 시각", selection: $wake, components: .time)
                    SHDivider()
                    SHDatePicker(
                        "취침",
                        selection: $bed,
                        subtitle: "날짜까지 고를 수 있어요",
                        components: .dateAndTime
                    )

                    SHDivider()
                    SHText("wheel", \.labelMedium, role: .secondary)
                    SHDatePicker(
                        "몇 시에 일어나세요?",
                        selection: $wake,
                        components: .time,
                        style: .wheel
                    )
                }
                .padding()
            }
        }
    }
    return Demo()
        .background(SHThemeBackground())
        .shTheme(.lavender)
}
