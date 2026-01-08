//
//  ChipCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct ChipCatalogView: View {
    @State private var selectedChips: Set<String> = ["Swift"]
    @State private var singleSelection: Set<String> = ["옵션1"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // Chip Styles
                sectionHeader("Chip Styles")

                ForEach(SHChipStyle.allCases, id: \.self) { style in
                    SHCard(style: .outlined) {
                        VStack(alignment: .leading, spacing: SH.spacing.sm) {
                            Text(style.displayName)
                                .font(SH.typography.labelMedium)
                                .foregroundStyle(SH.colors.textSecondary)

                            HStack(spacing: SH.spacing.sm) {
                                SHChip("기본", style: style)
                                SHChip("선택됨", style: style, isSelected: true)
                                SHChip("아이콘", icon: "star.fill", style: style)
                            }
                        }
                    }
                }

                // Chip Sizes
                sectionHeader("Chip Sizes")

                SHCard(style: .outlined) {
                    VStack(alignment: .leading, spacing: SH.spacing.md) {
                        ForEach(SHChipSize.allCases, id: \.self) { size in
                            HStack {
                                Text(size.rawValue.capitalized)
                                    .font(SH.typography.labelMedium)
                                    .foregroundStyle(SH.colors.textSecondary)
                                    .frame(width: 80, alignment: .leading)

                                SHChip("칩", size: size)
                                SHChip("아이콘", icon: "star.fill", size: size)
                            }
                        }
                    }
                }

                // Dismissible Chips
                sectionHeader("Dismissible Chips")

                SHCard(style: .outlined) {
                    FlowLayout(spacing: SH.spacing.sm) {
                        SHChip("Swift", isDismissible: true) {}
                        SHChip("SwiftUI", icon: "swift", isDismissible: true) {}
                        SHChip("iOS", style: .outlined, isDismissible: true) {}
                        SHChip("Xcode", style: .glass, isDismissible: true) {}
                    }
                }

                // Chip Group (Multi Select)
                sectionHeader("Chip Group (Multi Select)")

                SHCard(style: .outlined) {
                    VStack(alignment: .leading, spacing: SH.spacing.sm) {
                        Text("선택된 항목: \(selectedChips.joined(separator: ", "))")
                            .font(SH.typography.caption)
                            .foregroundStyle(SH.colors.textSecondary)

                        SHChipGroup(
                            chips: ["Swift", "SwiftUI", "UIKit", "Combine", "Core Data", "CloudKit"],
                            selectedChips: $selectedChips
                        )
                    }
                }

                // Chip Group (Single Select)
                sectionHeader("Chip Group (Single Select)")

                SHCard(style: .outlined) {
                    VStack(alignment: .leading, spacing: SH.spacing.sm) {
                        Text("선택: \(singleSelection.first ?? "없음")")
                            .font(SH.typography.caption)
                            .foregroundStyle(SH.colors.textSecondary)

                        SHChipGroup(
                            chips: ["옵션1", "옵션2", "옵션3", "옵션4"],
                            selectedChips: $singleSelection,
                            style: .outlined,
                            allowsMultipleSelection: false
                        )
                    }
                }

                // Filter Example
                sectionHeader("Filter Example")

                SHCard(style: .glass) {
                    VStack(alignment: .leading, spacing: SH.spacing.md) {
                        Text("카테고리 필터")
                            .font(SH.typography.titleSmall)
                            .foregroundStyle(SH.colors.textPrimary)

                        SHChipGroup(
                            chips: ["전체", "의류", "신발", "가방", "액세서리"],
                            selectedChips: $singleSelection,
                            style: .glass,
                            size: .small,
                            allowsMultipleSelection: false
                        )
                    }
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Chips")
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(SH.typography.titleSmall)
            .foregroundStyle(SH.colors.textPrimary)
    }
}

#Preview {
    NavigationStack {
        ChipCatalogView()
            .shTheme(.pastelPink)
    }
}
