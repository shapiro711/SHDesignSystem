//
//  TextFieldCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct TextFieldCatalogView: View {
    @State private var text = ""
    @State private var multilineText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // TextField Styles
                sectionHeader("TextField Styles")

                ForEach(SHTextFieldStyle.allCases, id: \.self) { style in
                    VStack(alignment: .leading, spacing: SH.spacing.xs) {
                        Text(style.displayName)
                            .font(SH.typography.labelMedium)
                            .foregroundStyle(SH.colors.textSecondary)

                        SHTextField("플레이스홀더", text: $text, style: style)
                    }
                }

                // With Icons
                sectionHeader("With Icons")

                SHTextField("이메일", text: $text, icon: "envelope")
                SHTextField("비밀번호", text: $text, icon: "lock", isSecure: true)
                SHTextField("검색", text: $text, style: .glass, icon: "magnifyingglass")

                // States
                sectionHeader("States")

                SHCard(style: .outlined) {
                    VStack(spacing: SH.spacing.md) {
                        VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                            Text("Normal")
                                .font(SH.typography.captionSmall)
                                .foregroundStyle(SH.colors.textTertiary)
                            SHTextField("일반 상태", text: .constant("입력값"), state: .normal)
                        }

                        VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                            Text("Error")
                                .font(SH.typography.captionSmall)
                                .foregroundStyle(SH.colors.textTertiary)
                            SHTextField("에러 상태", text: .constant("잘못된 입력"), state: .error)
                        }

                        VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                            Text("Success")
                                .font(SH.typography.captionSmall)
                                .foregroundStyle(SH.colors.textTertiary)
                            SHTextField("성공 상태", text: .constant("올바른 입력"), state: .success)
                        }

                        VStack(alignment: .leading, spacing: SH.spacing.xxs) {
                            Text("Disabled")
                                .font(SH.typography.captionSmall)
                                .foregroundStyle(SH.colors.textTertiary)
                            SHTextField("비활성 상태", text: .constant(""), state: .disabled)
                        }
                    }
                }

                // Text Area
                sectionHeader("Text Area")

                SHTextArea("여러 줄 입력...", text: $multilineText)
                SHTextArea("Glass Style", text: $multilineText, style: .glass, minHeight: 80)
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("TextFields")
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(SH.typography.titleSmall)
            .foregroundStyle(SH.colors.textPrimary)
    }
}

#Preview {
    NavigationStack {
        TextFieldCatalogView()
            .shTheme(.pastelMint)
    }
}
