//
//  SearchBarCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct SearchBarCatalogView: View {
    @State private var searchText = ""
    @State private var filledSearchText = "검색어"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // Styles
                sectionHeader("SearchBar Styles")

                ForEach(SHSearchBarStyle.allCases, id: \.self) { style in
                    VStack(alignment: .leading, spacing: SH.spacing.xs) {
                        Text(style.displayName)
                            .font(SH.typography.labelMedium)
                            .foregroundStyle(SH.colors.textSecondary)

                        SHSearchBar(text: $searchText, style: style)
                    }
                }

                // With Text
                sectionHeader("With Search Text")

                SHSearchBar(text: $filledSearchText)

                // Without Cancel Button
                sectionHeader("Without Cancel Button")

                SHSearchBar(text: $searchText, showsCancelButton: false)

                // Custom Placeholder
                sectionHeader("Custom Placeholder")

                SHSearchBar("상품 검색...", text: $searchText, style: .glass)
                SHSearchBar("장소 검색...", text: $searchText, style: .filled)

                // Interactive Example
                sectionHeader("Interactive Example")

                SHCard(style: .outlined) {
                    VStack(spacing: SH.spacing.md) {
                        SHSearchBar("친구 검색", text: $searchText, style: .glass)

                        if !searchText.isEmpty {
                            VStack(spacing: SH.spacing.xs) {
                                ForEach(filteredFriends, id: \.self) { friend in
                                    SHListItem(friend, style: .standard) {
                                        SHCircledIcon("person.fill", size: .sm, style: .filled)
                                    } trailing: {
                                        EmptyView()
                                    }
                                }
                            }
                        } else {
                            Text("검색어를 입력하세요")
                                .font(SH.typography.bodySmall)
                                .foregroundStyle(SH.colors.textTertiary)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Search Bar")
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(SH.typography.titleSmall)
            .foregroundStyle(SH.colors.textPrimary)
    }

    private var friends: [String] {
        ["김철수", "이영희", "박지민", "최수현", "정민준", "한소희"]
    }

    private var filteredFriends: [String] {
        friends.filter { $0.contains(searchText) }
    }
}

#Preview {
    NavigationStack {
        SearchBarCatalogView()
            .shTheme(.pastelMint)
    }
}
