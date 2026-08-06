import SwiftUI
import SHDesignSystemKit

// MARK: - Buttons

struct ButtonCatalog: View {
    @Environment(\.shTheme) private var theme
    @State private var isLoading = false

    var body: some View {
        CatalogPage {
            CatalogGroup("Variants") {
                VStack(spacing: SH.spacing.sm) {
                    ForEach(SHButtonVariant.allCases, id: \.self) { variant in
                        SHButton(variant.displayName, icon: "sparkles", variant: variant, fillsWidth: true) {}
                    }
                }
            }

            CatalogGroup("Sizes") {
                VStack(alignment: .leading, spacing: SH.spacing.sm) {
                    ForEach(SHControlSize.allCases, id: \.self) { size in
                        SHButton(size.rawValue.capitalized, icon: "star.fill", size: size) {}
                    }
                }
            }

            CatalogGroup("States") {
                VStack(spacing: SH.spacing.sm) {
                    SHButton("비활성", fillsWidth: true) {}
                        .disabled(true)
                    SHButton("로딩 중", isLoading: true, fillsWidth: true) {}
                    SHButton(isLoading ? "처리 중" : "탭해서 로딩", isLoading: isLoading, fillsWidth: true) {
                        isLoading = true
                        Task {
                            try? await Task.sleep(for: .seconds(1.5))
                            isLoading = false
                        }
                    }
                }
            }

            CatalogGroup("Icon Buttons — accessibilityLabel이 필수 인자입니다") {
                HStack(spacing: SH.spacing.md) {
                    ForEach(SHButtonVariant.allCases, id: \.self) { variant in
                        SHIconButton(icon: "heart.fill", accessibilityLabel: "좋아요", variant: variant) {}
                    }
                }
            }

            CatalogGroup("대비 — 이전 시스템에서 깨졌던 조합") {
                SHCard(surface: .outlined) {
                    VStack(alignment: .leading, spacing: SH.spacing.sm) {
                        SHButton("Primary", variant: .primary, fillsWidth: true) {}
                        SHButton("Destructive", variant: .destructive, fillsWidth: true) {}
                        SHText(
                            "채움색은 전경색과 4.5:1 이상이 되도록 밝기를 계산해서 뽑습니다. 색조를 바꿔도 유지됩니다.",
                            \.caption, role: .secondary
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Inputs

struct InputCatalog: View {
    @Environment(\.shTheme) private var theme

    @State private var plain = ""
    @State private var email = ""
    @State private var password = ""
    @State private var nickname = "몽글이"
    @State private var memo = ""
    @State private var search = ""
    @FocusState private var focusedField: Bool

    var body: some View {
        CatalogPage {
            CatalogGroup("Variants") {
                VStack(spacing: SH.spacing.sm) {
                    ForEach(SHFieldVariant.allCases, id: \.self) { variant in
                        SHTextField(variant.displayName, text: $plain, variant: variant, icon: "pencil")
                    }
                }
            }

            CatalogGroup("Form Fields") {
                VStack(spacing: SH.spacing.lg) {
                    SHInputField("이메일", text: $email,
                                 helperText: "로그인에 사용할 주소예요",
                                 icon: "envelope",
                                 keyboardType: .emailAddress,
                                 textContentType: .emailAddress,
                                 focus: $focusedField)

                    SHInputField("비밀번호", text: $password,
                                 icon: "lock", isSecure: true, isRequired: true,
                                 textContentType: .password)

                    SHInputField("닉네임", text: $nickname,
                                 validation: nickname == "몽글이"
                                     ? .error("이미 사용 중인 닉네임이에요")
                                     : .success("사용 가능해요"),
                                 icon: "person")
                }
            }

            CatalogGroup("Text Area") {
                SHTextArea("자유롭게 적어주세요", text: $memo, characterLimit: 200)
            }

            CatalogGroup("Search") {
                VStack(spacing: SH.spacing.sm) {
                    ForEach(SHFieldVariant.allCases, id: \.self) { variant in
                        SHSearchBar(text: $search, variant: variant)
                    }
                }
            }

            SHButton("첫 필드에 포커스", variant: .secondary, fillsWidth: true) {
                focusedField = true
            }
        }
    }
}

// MARK: - Selection

struct SelectionCatalog: View {
    @Environment(\.shTheme) private var theme

    @State private var toggle = true
    @State private var check = false
    @State private var terms = false
    @State private var radio: String? = "매일"
    @State private var segment = "주간"
    @State private var count = 2
    @State private var amount = 0.4
    @State private var chips: Set<String> = ["진행중"]

    var body: some View {
        CatalogPage {
            CatalogGroup("Toggle") {
                VStack(spacing: SH.spacing.sm) {
                    SHToggle("알림 받기", subtitle: "새 소식을 알려드려요", isOn: $toggle)
                    SHToggleRow("다크 모드", icon: "moon.fill", isOn: $check, surface: .elevated)
                }
            }

            CatalogGroup("Checkbox") {
                VStack(alignment: .leading, spacing: SH.spacing.xs) {
                    SHCheckbox("이용약관에 동의합니다", isChecked: $terms)
                    SHCheckbox("부분 선택", isChecked: .constant(false), isIndeterminate: true)
                }
            }

            CatalogGroup("Radio") {
                SHRadioGroup(["매일", "매주", "매월"], selection: $radio)
            }

            CatalogGroup("Segmented") {
                SHSegmentedControl(["일간", "주간", "월간"], selection: $segment)
            }

            CatalogGroup("Stepper") {
                SHStepper(value: $count, in: 0...10, label: "인원")
            }

            CatalogGroup("Slider") {
                SHSlider(value: $amount, label: "밝기") { "\(Int($0 * 100))%" }
            }

            CatalogGroup("Chip Group — 넘치면 다음 줄로 흐릅니다") {
                SHChipGroup(
                    ["전체", "진행중", "완료", "보관됨", "즐겨찾기", "공유됨", "최근 수정"],
                    selection: $chips
                )
            }
        }
    }
}
