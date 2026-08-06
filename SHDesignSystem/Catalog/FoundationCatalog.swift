import SwiftUI
import SHDesignSystemKit

// MARK: - Colors

struct ColorsCatalog: View {
    @Environment(\.shTheme) private var theme

    var body: some View {
        CatalogPage {
            CatalogGroup("Brand — 채움색과 컨테이너는 역할이 다릅니다") {
                pair("primary / onPrimary", theme.colors.primary, theme.colors.onPrimary)
                pair("primaryContainer / on…", theme.colors.primaryContainer, theme.colors.onPrimaryContainer)
                pair("secondary / onSecondary", theme.colors.secondary, theme.colors.onSecondary)
                pair("secondaryContainer / on…", theme.colors.secondaryContainer, theme.colors.onSecondaryContainer)
            }

            CatalogGroup("Surfaces") {
                pair("background", theme.colors.background, theme.colors.textPrimary)
                pair("surface", theme.colors.surface, theme.colors.textPrimary)
                pair("surfaceElevated", theme.colors.surfaceElevated, theme.colors.textPrimary)
                pair("surfaceSunken", theme.colors.surfaceSunken, theme.colors.textPrimary)
            }

            CatalogGroup("Text — 표면 위 글자색") {
                textSample("textPrimary", theme.colors.textPrimary)
                textSample("textSecondary", theme.colors.textSecondary)
                textSample("textTertiary", theme.colors.textTertiary)
                textSample("primaryText (브랜드 강조)", theme.colors.primaryText)
            }

            CatalogGroup("Status") {
                ForEach(SHStatusKind.allCases, id: \.self) { kind in
                    pair(kind.rawValue, theme.colors.fill(for: kind), theme.colors.onFill(for: kind))
                    pair("\(kind.rawValue)Container",
                         theme.colors.container(for: kind),
                         theme.colors.onContainer(for: kind))
                }
            }
        }
    }

    private func pair(_ name: String, _ background: Color, _ foreground: Color) -> some View {
        HStack {
            SHText(name, \.bodyMedium, role: .custom(foreground))
            Spacer()
            SHText("Aa", \.titleMedium, role: .custom(foreground))
        }
        .padding(.horizontal, SH.spacing.md)
        .frame(height: 52)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: SH.radius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SH.radius.md, style: .continuous)
                .stroke(theme.colors.border, lineWidth: 1)
        )
    }

    private func textSample(_ name: String, _ color: Color) -> some View {
        SHText(name, \.bodyLarge, role: .custom(color))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, SH.spacing.md)
            .frame(height: 44)
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: SH.radius.md, style: .continuous))
    }
}

// MARK: - Typography

struct TypographyCatalog: View {
    @Environment(\.shTheme) private var theme

    private let samples: [(String, KeyPath<SHTypographyScheme, SHFontToken>)] = [
        ("displayLarge", \.displayLarge),
        ("displayMedium", \.displayMedium),
        ("displaySmall", \.displaySmall),
        ("headlineLarge", \.headlineLarge),
        ("headlineMedium", \.headlineMedium),
        ("headlineSmall", \.headlineSmall),
        ("titleLarge", \.titleLarge),
        ("titleMedium", \.titleMedium),
        ("titleSmall", \.titleSmall),
        ("bodyLarge", \.bodyLarge),
        ("bodyMedium", \.bodyMedium),
        ("bodySmall", \.bodySmall),
        ("labelLarge", \.labelLarge),
        ("labelMedium", \.labelMedium),
        ("labelSmall", \.labelSmall),
        ("caption", \.caption),
        ("captionSmall", \.captionSmall)
    ]

    var body: some View {
        CatalogPage {
            SHCard(surface: .tinted) {
                SHText(
                    "모든 토큰이 Dynamic Type을 따릅니다. 설정 › 손쉬운 사용 › 화면 표시에서 글자 크기를 바꾸면 이 화면도 함께 커집니다.",
                    \.bodySmall,
                    role: .custom(theme.colors.onPrimaryContainer)
                )
            }

            CatalogGroup("Scale") {
                VStack(alignment: .leading, spacing: SH.spacing.md) {
                    ForEach(samples, id: \.0) { name, keyPath in
                        VStack(alignment: .leading, spacing: SH.spacing.xxxs) {
                            SHText(name, \.captionSmall, role: .tertiary)
                            SHText("몽글몽글 디자인 Aa 123", keyPath)
                        }
                    }
                }
            }

            CatalogGroup("본문 행간 — 한글 두 줄 이상") {
                SHCard(surface: .outlined) {
                    SHText(
                        "디자인 시스템은 화면을 빠르게 찍어내기 위한 도구입니다. 행간이 좁으면 한글 본문은 급격히 읽기 어려워지므로 본문 토큰은 1.5배 행간을 씁니다.",
                        \.bodyLarge
                    )
                }
            }
        }
    }
}

// MARK: - Layout

struct LayoutCatalog: View {
    @Environment(\.shTheme) private var theme

    private let spacings: [(String, CGFloat)] = [
        ("xxxs", SH.spacing.xxxs), ("xxs", SH.spacing.xxs), ("xs", SH.spacing.xs),
        ("sm", SH.spacing.sm), ("md", SH.spacing.md), ("lg", SH.spacing.lg),
        ("xl", SH.spacing.xl), ("xxl", SH.spacing.xxl), ("xxxl", SH.spacing.xxxl),
        ("section", SH.spacing.section), ("page", SH.spacing.page)
    ]

    var body: some View {
        CatalogPage {
            CatalogGroup("Spacing") {
                VStack(alignment: .leading, spacing: SH.spacing.xs) {
                    ForEach(spacings, id: \.0) { name, value in
                        HStack(spacing: SH.spacing.sm) {
                            SHText(name, \.labelSmall, role: .secondary)
                                .frame(width: 56, alignment: .leading)
                            Capsule()
                                .fill(theme.colors.primary)
                                .frame(width: value, height: 10)
                            SHText("\(Int(value))", \.captionSmall, role: .tertiary)
                        }
                    }
                }
            }

            CatalogGroup("Shape — 컴포넌트별 역할 토큰") {
                VStack(spacing: SH.spacing.xs) {
                    shape("button", theme.shape.button)
                    shape("control", theme.shape.control)
                    shape("card", theme.shape.card)
                    shape("container", theme.shape.container)
                    shape("sheet", theme.shape.sheet)
                    shape("chip", theme.shape.chip)
                    shape("thumbnail", theme.shape.thumbnail)
                }
            }

            CatalogGroup("Elevation") {
                VStack(spacing: SH.spacing.lg) {
                    elevation("raised", theme.elevation.raised)
                    elevation("floating", theme.elevation.floating)
                    elevation("overlay", theme.elevation.overlay)
                }
                .padding(.vertical, SH.spacing.sm)
            }
        }
    }

    private func shape(_ name: String, _ style: SHCornerStyle) -> some View {
        HStack(spacing: SH.spacing.md) {
            style.shape
                .fill(theme.colors.primaryContainer)
                .frame(width: 84, height: 48)
            SHText(name, \.bodyMedium)
            Spacer()
        }
    }

    private func elevation(_ name: String, _ token: SHShadowToken) -> some View {
        HStack(spacing: SH.spacing.md) {
            RoundedRectangle(cornerRadius: SH.radius.lg, style: .continuous)
                .fill(theme.colors.surface)
                .frame(width: 84, height: 48)
                .shShadow(token)
            SHText(name, \.bodyMedium)
            Spacer()
            SHText("r\(Int(token.radius)) y\(Int(token.y))", \.captionSmall, role: .tertiary)
        }
    }
}
