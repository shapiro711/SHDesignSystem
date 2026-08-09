import SwiftUI
import SHDesignSystemKit

struct ContentView: View {
    @State private var hue: Double = 268
    @State private var presetName: String? = "Lavender"

    private var theme: SHTheme { SHTheme(hue: hue) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SH.spacing.lg) {
                    ThemeStudio(hue: $hue, presetName: $presetName)
                    sections
                }
                .padding(SH.spacing.md)
            }
            .background(SHThemeBackground())
            .shNavigationBar("SH Design System")
        }
        .shTheme(theme)
    }

    private var sections: some View {
        VStack(spacing: SH.spacing.sm) {
            SHSectionHeader("Foundation")
            link("컬러", "paintpalette.fill") { ColorsCatalog() }
            link("타이포그래피", "textformat") { TypographyCatalog() }
            link("간격 · 모양 · 깊이", "square.on.square") { LayoutCatalog() }

            SHSectionHeader("Controls")
            link("버튼", "hand.tap.fill") { ButtonCatalog() }
            link("입력", "character.cursor.ibeam") { InputCatalog() }
            link("선택", "checklist") { SelectionCatalog() }

            SHSectionHeader("Display")
            link("카드 · 리스트", "rectangle.stack.fill") { DisplayCatalog() }
            link("칩 · 배지 · 아바타", "tag.fill") { AccentCatalog() }

            SHSectionHeader("Feedback & States")
            link("토스트 · 다이얼로그 · 시트", "bell.badge.fill") { FeedbackCatalog() }
            link("로딩 · 빈 화면 · 에러", "hourglass") { StateCatalog() }

            SHSectionHeader("Navigation")
            link("헤더 · 탭바", "square.grid.2x2.fill") { NavigationCatalog() }
        }
    }

    private func link<Destination: View>(
        _ title: String,
        _ icon: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink {
            destination()
                .background(SHThemeBackground())
                .shNavigationBar(title)
        } label: {
            SHCard(surface: .elevated, padding: SH.spacing.sm) {
                HStack(spacing: SH.spacing.md) {
                    SHCircledIcon(icon, size: .md, role: .tinted)
                    SHText(title, \.bodyLarge)
                    Spacer()
                    SHIcon("chevron.right", size: .sm)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Theme Studio

/// 이 디자인 시스템의 핵심 주장을 그대로 보여주는 화면.
/// 색조 슬라이더 하나를 움직이면 전체 팔레트가 다시 생성된다.
struct ThemeStudio: View {
    @Environment(\.shTheme) private var theme

    @Binding var hue: Double
    @Binding var presetName: String?

    var body: some View {
        SHCard(surface: .elevated) {
            VStack(alignment: .leading, spacing: SH.spacing.md) {
                HStack {
                    SHText("테마", \.titleMedium)
                    Spacer()
                    SHText("hue \(Int(hue))°", \.labelMedium, role: .brand)
                }

                swatchRow

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: SH.spacing.xs) {
                        ForEach(SHTheme.presets, id: \.name) { preset in
                            presetButton(preset.name)
                        }
                    }
                    .padding(.horizontal, 1)
                }

                SHSlider(value: $hue, in: 0...359, step: 1, label: "색조") {
                    "\(Int($0))°"
                }
                .onChange(of: hue) { _, _ in presetName = nil }

                SHText(
                    "색조 하나로 채움색·컨테이너·글자색이 다시 계산됩니다. 어떤 값에서도 WCAG AA 대비가 유지됩니다.",
                    \.caption,
                    role: .secondary
                )
            }
        }
    }

    private var swatchRow: some View {
        HStack(spacing: SH.spacing.xs) {
            swatch(theme.colors.primary, "Fill", on: theme.colors.onPrimary)
            swatch(theme.colors.primaryContainer, "Container", on: theme.colors.onPrimaryContainer)
            swatch(theme.colors.secondary, "Second", on: theme.colors.onSecondary)
            swatch(theme.colors.surfaceSunken, "Sunken", on: theme.colors.textSecondary)
        }
    }

    private func swatch(_ color: Color, _ label: String, on foreground: Color) -> some View {
        Text(label)
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: SH.radius.md, style: .continuous))
    }

    private func presetButton(_ name: String) -> some View {
        let preset = SHTheme.presets.first { $0.name == name }

        return Button {
            withAnimation(theme.motion.standard) {
                hue = Self.presetHue(for: name) ?? hue
                presetName = name
            }
        } label: {
            HStack(spacing: SH.spacing.xxs) {
                Circle()
                    .fill(preset?.theme.colors.primary ?? .clear)
                    .frame(width: 14, height: 14)
                Text(name)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
            }
            .padding(.horizontal, SH.spacing.sm)
            .frame(height: 34)
            .foregroundStyle(
                presetName == name ? theme.colors.onPrimaryContainer : theme.colors.textSecondary
            )
            .background(presetName == name ? theme.colors.primaryContainer : theme.colors.surfaceSunken)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    static func presetHue(for name: String) -> Double? {
        switch name {
        case "Lavender": return 268
        case "Pink": return 340
        case "Mint": return 166
        case "Peach": return 22
        case "Sky": return 205
        case "Lemon": return 48
        default: return nil
        }
    }
}

// MARK: - Shared Catalog Chrome

struct CatalogPage<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                content
            }
            .padding(SH.spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct CatalogGroup<Content: View>: View {
    let title: String
    let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SH.spacing.sm) {
            SHText(title, \.labelMedium, role: .secondary)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ContentView()
}
