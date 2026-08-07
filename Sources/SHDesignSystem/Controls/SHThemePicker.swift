import SwiftUI

// MARK: - SHThemePicker

/// 색조 선택.
///
/// SH는 "시그니처는 고정, 색조만 앱마다 다름"을 전제로 하므로, 설정 화면에서
/// 사용자에게 색조를 열어 주는 앱이 많다. 그때마다 프리셋 목록과 선택 판정을
/// 앱이 직접 만들면 `SHTheme.presets`와 중복된다.
///
/// 선택값은 **hue(Double)** 로 주고받는다. 앱은 이 값만 저장했다가
/// `shTheme(hue:)`로 되돌리면 된다.
///
/// ```swift
/// SHThemePicker(selection: $settings.themeHue)
/// SHThemePicker(selection: $hue, themes: [("바다", .sky), ("숲", SHTheme(hue: 140))])
/// ```
public struct SHThemePicker: View {
    @Environment(\.shTheme) private var theme

    @Binding private var selection: Double

    private let themes: [(name: String, theme: SHTheme)]
    private let swatchSize: CGFloat

    public init(
        selection: Binding<Double>,
        themes: [(name: String, theme: SHTheme)] = SHTheme.presets,
        swatchSize: CGFloat = SH.size.iconXL
    ) {
        self._selection = selection
        self.themes = themes
        self.swatchSize = swatchSize
    }

    public var body: some View {
        HStack(spacing: SH.spacing.xs) {
            ForEach(themes, id: \.name) { preset in
                swatch(name: preset.name, preset: preset.theme)
            }
        }
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private func swatch(name: String, preset: SHTheme) -> some View {
        // 팔레트를 직접 넘겨 만든 테마는 hue가 없어 선택 대상이 될 수 없다.
        if let hue = preset.hue {
            let isSelected = abs(selection - hue) < 0.5

            Button {
                selection = hue
                SHHaptics.selection()
            } label: {
                Circle()
                    .fill(preset.colors.primary)
                    .frame(width: swatchSize, height: swatchSize)
                    .overlay {
                        Circle()
                            .stroke(
                                theme.colors.textPrimary,
                                lineWidth: isSelected ? SH.size.borderEmphasis : 0
                            )
                    }
                    .shMinTapTarget()
            }
            .buttonStyle(.shPressable(haptic: nil))
            .accessibilityLabel(Text(name))
            .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        }
    }
}

// MARK: - Preview

#Preview("SHThemePicker") {
    struct Demo: View {
        @State private var hue: Double = 268

        var body: some View {
            VStack(alignment: .leading, spacing: SH.spacing.lg) {
                SHSectionHeader("테마")
                SHThemePicker(selection: $hue)
                SHButton("주요 버튼", variant: .primary, fillsWidth: true) { }
                SHCard(surface: .tinted) {
                    SHText("고른 색조가 화면 전체에 적용돼요", \.bodyMedium)
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            // 고른 색조를 그 자리에서 되먹여 미리보기
            .background(SHThemeBackground())
            .shTheme(hue: hue)
        }
    }
    return Demo()
}
