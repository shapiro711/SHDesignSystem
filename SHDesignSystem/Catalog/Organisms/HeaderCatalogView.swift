//
//  HeaderCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct HeaderCatalogView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // Header Styles
                sectionHeader("Header Styles")

                ForEach(SHHeaderStyle.allCases, id: \.self) { style in
                    VStack(alignment: .leading, spacing: SH.spacing.xs) {
                        Text(style.displayName)
                            .font(SH.typography.labelMedium)
                            .foregroundStyle(SH.colors.textSecondary)
                            .padding(.horizontal, SH.spacing.md)

                        SHCard(style: .outlined, padding: 0) {
                            SHHeader("헤더 타이틀", subtitle: "서브타이틀", style: style) {
                                SHIconButton(icon: "chevron.left", style: .ghost) {}
                            } trailingAction: {
                                SHIconButton(icon: "ellipsis", style: .ghost) {}
                            }
                        }
                    }
                }

                // Navigation Header
                sectionHeader("Navigation Header")

                SHCard(style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        SHNavigationHeader("설정", trailingIcon: "gear")
                        SHDivider()
                        SHNavigationHeader("프로필", showBackButton: true, trailingIcon: "pencil")
                    }
                }

                // Section Header
                sectionHeader("Section Headers")

                VStack(spacing: SH.spacing.sm) {
                    SHSectionHeader("최근 항목", actionTitle: "모두 보기") {}
                    SHSectionHeader("추천")
                    SHSectionHeader("인기 항목", actionTitle: "더보기") {}
                }

                // Large Header Example
                sectionHeader("Large Header Example")

                SHCard(style: .glass, padding: 0) {
                    SHHeader("안녕하세요", subtitle: "오늘도 좋은 하루 되세요!", style: .large) {
                        EmptyView()
                    } trailingAction: {
                        SHCircledIcon("person.fill", size: .lg, style: .filled)
                    }
                }

                // Header with Search
                sectionHeader("Header + Search Example")

                SHCard(style: .outlined, padding: 0) {
                    VStack(spacing: 0) {
                        SHHeader("검색", style: .standard) {
                            EmptyView()
                        } trailingAction: {
                            SHIconButton(icon: "slider.horizontal.3", style: .ghost) {}
                        }

                        SHSearchBar(text: .constant(""), style: .filled)
                            .padding(SH.spacing.md)
                    }
                }

                // Glass Header on Gradient
                sectionHeader("Glass Header on Gradient")

                ZStack(alignment: .top) {
                    LinearGradient(
                        colors: [SH.colors.lavender, SH.colors.pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: SH.radius.xxl, style: .continuous))

                    SHHeader("Glass Header", subtitle: "배경 위의 글래스 효과", style: .glass) {
                        SHIconButton(icon: "chevron.left", style: .glass) {}
                    } trailingAction: {
                        SHIconButton(icon: "heart", style: .glass) {}
                    }
                    .clipShape(RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous))
                    .padding(SH.spacing.md)
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Headers")
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(SH.typography.titleSmall)
            .foregroundStyle(SH.colors.textPrimary)
    }
}

#Preview {
    NavigationStack {
        HeaderCatalogView()
            .shTheme(.pastelMint)
    }
}
