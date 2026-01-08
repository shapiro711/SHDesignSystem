//
//  ListItemCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct ListItemCatalogView: View {
    @State private var toggle1 = true
    @State private var toggle2 = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // ListItem Styles
                sectionHeader("ListItem Styles")

                ForEach(SHListItemStyle.allCases, id: \.self) { style in
                    SHListItem("리스트 아이템", subtitle: style.displayName, style: style) {
                        SHCircledIcon("star.fill", size: .md, style: .filled)
                    } trailing: {
                        Text("값")
                            .font(SH.typography.bodySmall)
                            .foregroundStyle(SH.colors.textSecondary)
                    }
                }

                // Navigation Items
                sectionHeader("Navigation Items")

                VStack(spacing: SH.spacing.sm) {
                    SHNavigationListItem("프로필", subtitle: "이름, 사진 변경", icon: "person.fill") {}
                    SHNavigationListItem("알림 설정", icon: "bell.fill") {}
                    SHNavigationListItem("개인정보", icon: "lock.fill") {}
                    SHNavigationListItem("도움말", icon: "questionmark.circle.fill") {}
                }

                // Toggle Items
                sectionHeader("Toggle Items")

                VStack(spacing: SH.spacing.sm) {
                    SHToggleListItem("다크 모드", icon: "moon.fill", isOn: $toggle1)
                    SHToggleListItem("알림 받기", subtitle: "푸시 알림을 받습니다", icon: "bell.fill", isOn: $toggle2)
                    SHToggleListItem("자동 업데이트", icon: "arrow.down.circle.fill", isOn: $toggle1, style: .card)
                }

                // Card Style List
                sectionHeader("Card Style List")

                VStack(spacing: SH.spacing.sm) {
                    SHListItem("설정", subtitle: "앱 설정을 관리합니다", style: .card) {
                        SHCircledIcon("gear", size: .md, style: .filled)
                    } trailing: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(SH.colors.textTertiary)
                    } action: {}

                    SHListItem("저장소", subtitle: "12.5 GB 사용 중", style: .card) {
                        SHCircledIcon("externaldrive.fill", size: .md, style: .filled)
                    } trailing: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(SH.colors.textTertiary)
                    } action: {}
                }

                // Glass Style List
                sectionHeader("Glass Style List")

                VStack(spacing: SH.spacing.sm) {
                    SHListItem("프리미엄", subtitle: "더 많은 기능을 사용해보세요", style: .glass) {
                        SHCircledIcon("crown.fill", size: .md, style: .glass)
                    } trailing: {
                        SHChip("업그레이드", style: .filled, size: .small)
                    }

                    SHNavigationListItem("초대하기", subtitle: "친구를 초대하고 혜택을 받으세요", icon: "gift.fill", style: .glass) {}
                }

                // Simple List
                sectionHeader("Simple List")

                SHCard(style: .outlined) {
                    VStack(spacing: 0) {
                        ForEach(["계정", "보안", "알림", "언어", "정보"], id: \.self) { item in
                            SHListItem(item) {
                                EmptyView()
                            } trailing: {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(SH.colors.textTertiary)
                            } action: {}

                            if item != "정보" {
                                SHDivider()
                                    .padding(.leading, SH.spacing.md)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("List Items")
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(SH.typography.titleSmall)
            .foregroundStyle(SH.colors.textPrimary)
    }
}

#Preview {
    NavigationStack {
        ListItemCatalogView()
            .shTheme(.pastelLavender)
    }
}
