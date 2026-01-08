import SwiftUI

// MARK: - SHInputField (Label + TextField)
public struct SHInputField: View {
    @Environment(\.shTheme) private var theme

    @Binding private var text: String
    private let label: String
    private let placeholder: String
    private let helperText: String?
    private let errorText: String?
    private let style: SHTextFieldStyle
    private let icon: String?
    private let isSecure: Bool
    private let isRequired: Bool

    public init(
        _ label: String,
        placeholder: String = "",
        text: Binding<String>,
        helperText: String? = nil,
        errorText: String? = nil,
        style: SHTextFieldStyle = .outlined,
        icon: String? = nil,
        isSecure: Bool = false,
        isRequired: Bool = false
    ) {
        self.label = label
        self.placeholder = placeholder.isEmpty ? label : placeholder
        self._text = text
        self.helperText = helperText
        self.errorText = errorText
        self.style = style
        self.icon = icon
        self.isSecure = isSecure
        self.isRequired = isRequired
    }

    private var hasError: Bool {
        errorText != nil && !errorText!.isEmpty
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SH.spacing.xs) {
            // Label
            HStack(spacing: SH.spacing.xxs) {
                Text(label)
                    .font(SH.typography.labelMedium)
                    .foregroundStyle(hasError ? SH.colors.error : SH.colors.textPrimary)

                if isRequired {
                    Text("*")
                        .font(SH.typography.labelMedium)
                        .foregroundStyle(SH.colors.error)
                }
            }

            // TextField
            SHTextField(
                placeholder,
                text: $text,
                style: style,
                icon: icon,
                isSecure: isSecure,
                state: hasError ? .error : .normal
            )

            // Helper/Error Text
            if let error = errorText, !error.isEmpty {
                HStack(spacing: SH.spacing.xxs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                    Text(error)
                        .font(SH.typography.caption)
                }
                .foregroundStyle(SH.colors.error)
            } else if let helper = helperText {
                Text(helper)
                    .font(SH.typography.caption)
                    .foregroundStyle(SH.colors.textTertiary)
            }
        }
    }
}

// MARK: - Preview
#Preview("SHInputField") {
    VStack(spacing: 24) {
        SHInputField(
            "이메일",
            text: .constant(""),
            helperText: "유효한 이메일을 입력해주세요",
            icon: "envelope"
        )

        SHInputField(
            "비밀번호",
            text: .constant("password123"),
            icon: "lock",
            isSecure: true,
            isRequired: true
        )

        SHInputField(
            "닉네임",
            text: .constant("already taken"),
            errorText: "이미 사용중인 닉네임입니다",
            icon: "person"
        )
    }
    .padding()
    .shTheme(.pastelLavender)
}
