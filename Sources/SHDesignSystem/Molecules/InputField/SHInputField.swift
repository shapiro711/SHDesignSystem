import SwiftUI

// MARK: - SHInputField
/// 라벨 + 입력 + 도움말/에러를 묶은 폼 필드.
/// 폼 화면은 이 단위로 조립한다.
public struct SHInputField: View {
    @Environment(\.shTheme) private var theme

    @Binding private var text: String

    private let label: String
    private let placeholder: String
    private let helperText: String?
    private let validation: SHFieldValidation
    private let variant: SHFieldVariant
    private let icon: String?
    private let isSecure: Bool
    private let isRequired: Bool
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let submitLabel: SubmitLabel
    private let focus: FocusState<Bool>.Binding?
    private let onSubmit: (() -> Void)?

    public init(
        _ label: String,
        placeholder: String? = nil,
        text: Binding<String>,
        helperText: String? = nil,
        validation: SHFieldValidation = .none,
        variant: SHFieldVariant = .outlined,
        icon: String? = nil,
        isSecure: Bool = false,
        isRequired: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        submitLabel: SubmitLabel = .return,
        focus: FocusState<Bool>.Binding? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder ?? label
        self._text = text
        self.helperText = helperText
        self.validation = validation
        self.variant = variant
        self.icon = icon
        self.isSecure = isSecure
        self.isRequired = isRequired
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.submitLabel = submitLabel
        self.focus = focus
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SH.spacing.xs) {
            labelRow

            SHTextField(
                placeholder,
                text: $text,
                variant: variant,
                icon: icon,
                isSecure: isSecure,
                validation: validation,
                keyboardType: keyboardType,
                textContentType: textContentType,
                submitLabel: submitLabel,
                focus: focus,
                onSubmit: onSubmit
            )

            footer
        }
        // 라벨과 입력을 하나의 접근성 요소로 묶어야 VoiceOver가
        // "이메일, 필수, 텍스트 필드"처럼 한 번에 읽는다.
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(accessibilityLabel))
    }

    private var labelRow: some View {
        HStack(spacing: SH.spacing.xxs) {
            SHText(label, \.labelMedium, role: validation.isError ? .status(.error) : .primary)
            if isRequired {
                SHText("*", \.labelMedium, role: .status(.error))
            }
        }
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var footer: some View {
        if let message = validation.message {
            HStack(spacing: SH.spacing.xxs) {
                Image(systemName: validation.isError ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                    .font(.system(size: SH.size.iconXS))
                SHText(message, \.caption, role: .custom(validation.isError ? theme.colors.error : theme.colors.success))
            }
            .foregroundStyle(validation.isError ? theme.colors.error : theme.colors.success)
            .transition(.opacity.combined(with: .move(edge: .top)))
        } else if let helperText {
            SHText(helperText, \.caption, role: .tertiary)
        }
    }

    private var accessibilityLabel: String {
        var parts = [label]
        if isRequired { parts.append("필수") }
        if case .error(let message) = validation { parts.append("오류, \(message)") }
        return parts.joined(separator: ", ")
    }
}

// MARK: - Preview

#Preview("SHInputField") {
    ScrollView {
        VStack(spacing: SH.spacing.xl) {
            SHInputField("이메일", text: .constant(""),
                         helperText: "로그인에 사용할 주소예요",
                         icon: "envelope", keyboardType: .emailAddress)

            SHInputField("비밀번호", text: .constant("secret"),
                         icon: "lock", isSecure: true, isRequired: true)

            SHInputField("닉네임", text: .constant("몽글이"),
                         validation: .error("이미 사용 중인 닉네임이에요"),
                         icon: "person")

            SHInputField("전화번호", text: .constant("010-0000-0000"),
                         validation: .success("사용 가능해요"),
                         variant: .filled, icon: "phone")
        }
        .padding()
    }
    .background(SHThemeBackground())
    .shTheme(.pink)
}
