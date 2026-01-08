//
//  BottomSheetCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct BottomSheetCatalogView: View {
    @State private var showStandardSheet = false
    @State private var showGlassSheet = false
    @State private var showSmallSheet = false
    @State private var showLargeSheet = false
    @State private var showActionSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // Standard Bottom Sheet
                sectionHeader("Standard Bottom Sheet")

                SHButton("Standard Sheet", style: .primary, isFullWidth: true) {
                    showStandardSheet = true
                }

                // Glass Bottom Sheet
                sectionHeader("Glass Bottom Sheet")

                SHButton("Glass Sheet", style: .glass, isFullWidth: true) {
                    showGlassSheet = true
                }

                // Detent Sizes
                sectionHeader("Detent Sizes")

                HStack(spacing: SH.spacing.md) {
                    SHButton("Small", style: .secondary) {
                        showSmallSheet = true
                    }

                    SHButton("Large", style: .secondary) {
                        showLargeSheet = true
                    }
                }

                // Action Sheet
                sectionHeader("Action Sheet")

                SHButton("Show Action Sheet", icon: "ellipsis", style: .outlined, isFullWidth: true) {
                    showActionSheet = true
                }

                // Preview Cards
                sectionHeader("Component Preview")

                SHCard(style: .outlined) {
                    VStack(alignment: .leading, spacing: SH.spacing.md) {
                        Text("SHActionSheet")
                            .font(SH.typography.titleSmall)

                        SHActionSheet(
                            title: "파일 옵션",
                            message: "이 파일로 무엇을 하시겠습니까?",
                            actions: [
                                .init("공유", icon: "square.and.arrow.up") {},
                                .init("복사", icon: "doc.on.doc") {},
                                .init("삭제", icon: "trash", style: .destructive) {}
                            ],
                            cancelAction: .init("취소", style: .cancel) {}
                        )
                    }
                }

                // Usage Example
                sectionHeader("Usage Code")

                SHCard(style: .filled) {
                    VStack(alignment: .leading, spacing: SH.spacing.sm) {
                        Text("사용 방법")
                            .font(SH.typography.labelMedium)
                            .foregroundStyle(SH.colors.textSecondary)

                        Text("""
                        .shBottomSheet(
                            isPresented: $isPresented,
                            detent: .medium,
                            style: .glass
                        ) {
                            // Content
                        }
                        """)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(SH.colors.textPrimary)
                    }
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Bottom Sheets")
        // Standard Sheet
        .shBottomSheet(isPresented: $showStandardSheet, style: .standard) {
            sheetContent("Standard Sheet")
        }
        // Glass Sheet
        .shBottomSheet(isPresented: $showGlassSheet, style: .glass) {
            sheetContent("Glass Sheet")
        }
        // Small Sheet
        .shBottomSheet(isPresented: $showSmallSheet, detent: .small, style: .glass) {
            VStack {
                Text("Small Detent")
                    .font(SH.typography.titleMedium)
                SHButton("닫기", style: .ghost) {
                    showSmallSheet = false
                }
            }
            .padding()
        }
        // Large Sheet
        .shBottomSheet(isPresented: $showLargeSheet, detent: .large, style: .glass) {
            sheetContent("Large Sheet")
        }
        // Action Sheet
        .shBottomSheet(isPresented: $showActionSheet, detent: .custom(0.4), style: .standard) {
            SHActionSheet(
                title: "옵션 선택",
                message: "원하는 작업을 선택하세요",
                actions: [
                    .init("수정", icon: "pencil") { showActionSheet = false },
                    .init("공유", icon: "square.and.arrow.up") { showActionSheet = false },
                    .init("삭제", icon: "trash", style: .destructive) { showActionSheet = false }
                ],
                cancelAction: .init("취소", style: .cancel) { showActionSheet = false }
            )
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(SH.typography.titleSmall)
            .foregroundStyle(SH.colors.textPrimary)
    }

    private func sheetContent(_ title: String) -> some View {
        VStack(spacing: SH.spacing.lg) {
            Text(title)
                .font(SH.typography.titleLarge)
                .foregroundStyle(SH.colors.textPrimary)

            Text("바텀 시트 내용입니다.\n다양한 컨텐츠를 담을 수 있습니다.")
                .font(SH.typography.bodyMedium)
                .foregroundStyle(SH.colors.textSecondary)
                .multilineTextAlignment(.center)

            SHDivider()

            VStack(spacing: SH.spacing.sm) {
                SHNavigationListItem("옵션 1", icon: "star.fill", style: .card) {}
                SHNavigationListItem("옵션 2", icon: "heart.fill", style: .card) {}
                SHNavigationListItem("옵션 3", icon: "bell.fill", style: .card) {}
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        BottomSheetCatalogView()
            .shTheme(.pastelPink)
    }
}
