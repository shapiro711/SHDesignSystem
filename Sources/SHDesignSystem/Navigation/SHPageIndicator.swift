import SwiftUI

// MARK: - SHPageIndicator

/// 단계·페이지 진행 표시.
///
/// 온보딩이나 캐러셀에서 "지금 몇 번째인가"를 보여 준다. 현재 페이지만 캡슐로 늘어나
/// 점 개수를 세지 않아도 위치가 읽힌다.
///
/// SwiftUI 기본 페이지 인디케이터(`TabView(.page)`)는 색·크기가 UIKit appearance
/// 전역 설정에 묶여 있어 테마별로 바꾸기 어렵다. 그래서 별도 컴포넌트로 둔다.
///
/// ```swift
/// SHPageIndicator(current: store.step, total: 3)
/// SHPageIndicator(current: index, total: pages.count) { index = $0 }
/// ```
public struct SHPageIndicator: View {
    @Environment(\.shTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let current: Int
    private let total: Int
    private let onSelect: ((Int) -> Void)?

    public init(current: Int, total: Int, onSelect: ((Int) -> Void)? = nil) {
        self.current = current
        self.total = total
        self.onSelect = onSelect
    }

    public var body: some View {
        HStack(spacing: SH.spacing.xxs) {
            ForEach(0..<max(0, total), id: \.self) { index in
                dot(at: index)
            }
        }
        // 개별 점이 아니라 "N단계 중 M단계"로 한 번에 읽는다.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(total)단계 중 \(current + 1)단계"))
    }

    private func dot(at index: Int) -> some View {
        let isCurrent = index == current

        return Capsule(style: .continuous)
            .fill(isCurrent ? theme.colors.primary : theme.colors.primaryContainer)
            .frame(width: isCurrent ? currentWidth : dotSize, height: dotSize)
            .animation(reduceMotion ? nil : theme.motion.standard, value: current)
            .contentShape(.capsule)
            .onTapGesture {
                guard let onSelect else { return }
                SHHaptics.selection()
                onSelect(index)
            }
    }

    private var dotSize: CGFloat { 8 }
    private var currentWidth: CGFloat { 20 }
}

// MARK: - Preview

#Preview("SHPageIndicator") {
    struct Demo: View {
        @State private var step = 0

        var body: some View {
            VStack(spacing: SH.spacing.xl) {
                SHPageIndicator(current: step, total: 3)
                SHPageIndicator(current: step, total: 5) { step = min($0, 2) }
                SHButton("다음") { step = (step + 1) % 3 }
            }
            .padding()
        }
    }
    return Demo()
        .background(SHThemeBackground())
        .shTheme(.peach)
}
