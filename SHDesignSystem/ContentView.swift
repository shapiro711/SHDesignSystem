//
//  ContentView.swift
//  SHDesignSystem
//
//  Created by Kim Do hyung on 1/8/26.
//

import SwiftUI
import SHDesignSystemKit

struct ContentView: View {
    @State private var selectedTheme: SHTheme = .pastelLavender

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SH.spacing.lg) {
                    // Theme Selector
                    themeSelector

                    // Catalog Sections
                    catalogSections
                }
                .padding()
            }
            .background(SH.colors.background)
            .navigationTitle("SH Design System")
            .shTheme(selectedTheme)
        }
    }

    private var themeSelector: some View {
        SHCard(style: .glass) {
            VStack(alignment: .leading, spacing: SH.spacing.sm) {
                Text("Theme")
                    .font(SH.typography.labelMedium)
                    .foregroundStyle(SH.colors.textSecondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: SH.spacing.sm) {
                        ForEach(SHTheme.allCases, id: \.self) { theme in
                            themeButton(theme)
                        }
                    }
                }
            }
        }
    }

    private func themeButton(_ theme: SHTheme) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selectedTheme = theme
            }
        } label: {
            VStack(spacing: SH.spacing.xs) {
                Circle()
                    .fill(theme.primaryColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(selectedTheme == theme ? SH.colors.textPrimary : .clear, lineWidth: 2)
                    )

                Text(theme.displayName)
                    .font(SH.typography.captionSmall)
                    .foregroundStyle(SH.colors.textSecondary)
            }
        }
        .buttonStyle(.plain)
    }

    private var catalogSections: some View {
        VStack(spacing: SH.spacing.md) {
            SHSectionHeader("Foundation")

            NavigationLink(destination: ColorsCatalogView()) {
                catalogItem("Colors", icon: "paintpalette.fill", description: "컬러 팔레트 & 시맨틱 컬러")
            }

            NavigationLink(destination: TypographyCatalogView()) {
                catalogItem("Typography", icon: "textformat", description: "폰트 스타일 & 텍스트")
            }

            NavigationLink(destination: SpacingCatalogView()) {
                catalogItem("Spacing & Radius", icon: "square.resize", description: "간격 & 둥근 모서리")
            }

            SHSectionHeader("Atoms")

            NavigationLink(destination: ButtonCatalogView()) {
                catalogItem("Buttons", icon: "rectangle.fill", description: "버튼 스타일 & 사이즈")
            }

            NavigationLink(destination: TextFieldCatalogView()) {
                catalogItem("TextFields", icon: "character.cursor.ibeam", description: "입력 필드 & 텍스트 에어리어")
            }

            NavigationLink(destination: IconCatalogView()) {
                catalogItem("Icons", icon: "star.fill", description: "아이콘 & 아이콘 버튼")
            }

            SHSectionHeader("Molecules")

            NavigationLink(destination: InputFieldCatalogView()) {
                catalogItem("Input Fields", icon: "rectangle.and.pencil.and.ellipsis", description: "라벨 + 입력 필드")
            }

            NavigationLink(destination: SearchBarCatalogView()) {
                catalogItem("Search Bar", icon: "magnifyingglass", description: "검색 바 스타일")
            }

            NavigationLink(destination: ChipCatalogView()) {
                catalogItem("Chips", icon: "tag.fill", description: "칩 & 칩 그룹")
            }

            NavigationLink(destination: ListItemCatalogView()) {
                catalogItem("List Items", icon: "list.bullet", description: "리스트 아이템 & 네비게이션")
            }

            SHSectionHeader("Organisms")

            NavigationLink(destination: CardCatalogView()) {
                catalogItem("Cards", icon: "rectangle.portrait.fill", description: "카드 스타일 & 변형")
            }

            NavigationLink(destination: HeaderCatalogView()) {
                catalogItem("Headers", icon: "rectangle.topthird.inset.filled", description: "헤더 & 섹션 헤더")
            }

            NavigationLink(destination: BottomSheetCatalogView()) {
                catalogItem("Bottom Sheets", icon: "rectangle.bottomthird.inset.filled", description: "바텀 시트 & 액션 시트")
            }
        }
    }

    private func catalogItem(_ title: String, icon: String, description: String) -> some View {
        SHCard(style: .outlined) {
            HStack(spacing: SH.spacing.md) {
                SHCircledIcon(icon, size: .md, style: .filled)

                VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                    Text(title)
                        .font(SH.typography.titleSmall)
                        .foregroundStyle(SH.colors.textPrimary)

                    Text(description)
                        .font(SH.typography.bodySmall)
                        .foregroundStyle(SH.colors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(SH.colors.textTertiary)
            }
        }
    }
}

#Preview {
    ContentView()
}
