//
//  InputFieldCatalogView.swift
//  SHDesignSystem
//

import SwiftUI
import SHDesignSystemKit

struct InputFieldCatalogView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var nickname = "taken_name"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SH.spacing.xl) {
                // Basic
                sectionHeader("Basic Input Field")

                SHInputField(
                    "이메일",
                    placeholder: "example@email.com",
                    text: $email,
                    helperText: "유효한 이메일을 입력해주세요",
                    icon: "envelope"
                )

                // Secure
                sectionHeader("Secure Input")

                SHInputField(
                    "비밀번호",
                    text: $password,
                    icon: "lock",
                    isSecure: true,
                    isRequired: true
                )

                // With Error
                sectionHeader("With Error State")

                SHInputField(
                    "닉네임",
                    text: $nickname,
                    errorText: "이미 사용중인 닉네임입니다",
                    icon: "person"
                )

                // Styles
                sectionHeader("TextField Styles")

                ForEach(SHTextFieldStyle.allCases, id: \.self) { style in
                    SHInputField(
                        "\(style.displayName) Style",
                        text: .constant(""),
                        style: style
                    )
                }

                // Form Example
                sectionHeader("Form Example")

                SHCard(style: .glass) {
                    VStack(spacing: SH.spacing.lg) {
                        SHInputField("이름", text: .constant(""), icon: "person", isRequired: true)
                        SHInputField("이메일", text: .constant(""), icon: "envelope", isRequired: true)
                        SHInputField("전화번호", text: .constant(""), helperText: "'-' 없이 입력", icon: "phone")
                        SHButton("가입하기", style: .primary, isFullWidth: true) {}
                    }
                }
            }
            .padding()
        }
        .background(SH.colors.background)
        .navigationTitle("Input Fields")
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(SH.typography.titleSmall)
            .foregroundStyle(SH.colors.textPrimary)
    }
}

#Preview {
    NavigationStack {
        InputFieldCatalogView()
            .shTheme(.pastelLavender)
    }
}
