import SwiftUI

// MARK: - Field Variant

public enum SHFieldVariant: String, Sendable, CaseIterable {
    case outlined
    case filled
    case glass

    public var displayName: String { rawValue.capitalized }
}

// MARK: - Validation

/// 필드의 검증 결과. 포커스처럼 뷰가 스스로 아는 상태와 달리
/// 검증은 바깥(리듀서)이 소유하므로 값으로 주입받는다.
public enum SHFieldValidation: Sendable, Equatable {
    case none
    case error(String)
    case success(String?)

    var message: String? {
        switch self {
        case .none: return nil
        case .error(let m): return m
        case .success(let m): return m
        }
    }

    var isError: Bool {
        if case .error = self { return true }
        return false
    }

    /// 옵셔널 에러 메시지를 그대로 넘길 때 쓴다.
    ///
    /// `errorMessage.map { .error($0) } ?? .none` 은 `.none`이 `Optional.none`과
    /// 겹쳐 경고가 나므로, 이 헬퍼를 쓰는 편이 안전하다.
    public static func error(ifPresent message: String?) -> SHFieldValidation {
        guard let message, !message.isEmpty else { return .none }
        return .error(message)
    }
}

// MARK: - SHTextField

public struct SHTextField: View {
    @Environment(\.shTheme) private var theme
    @FocusState private var internalFocus: Bool

    @Binding private var text: String

    private let placeholder: String
    private let variant: SHFieldVariant
    private let icon: String?
    private let isSecure: Bool
    private let validation: SHFieldValidation
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let submitLabel: SubmitLabel
    private let externalFocus: FocusState<Bool>.Binding?
    private let onSubmit: (() -> Void)?

    /// - Parameter focus: 바깥에서 포커스를 제어해야 할 때 넘긴다.
    ///   (다음 필드로 이동, 화면 진입 시 자동 포커스 등)
    public init(
        _ placeholder: String,
        text: Binding<String>,
        variant: SHFieldVariant = .outlined,
        icon: String? = nil,
        isSecure: Bool = false,
        validation: SHFieldValidation = .none,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        submitLabel: SubmitLabel = .return,
        focus: FocusState<Bool>.Binding? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.variant = variant
        self.icon = icon
        self.isSecure = isSecure
        self.validation = validation
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.submitLabel = submitLabel
        self.externalFocus = focus
        self.onSubmit = onSubmit
    }

    private var isFocused: Bool {
        externalFocus?.wrappedValue ?? internalFocus
    }

    public var body: some View {
        HStack(spacing: SH.spacing.sm) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: SH.size.iconMD, weight: .medium))
                    .foregroundStyle(accentColor)
                    .accessibilityHidden(true)
            }

            field
                // 포커스는 컨테이너가 아니라 실제 입력 뷰에 붙어야 한다.
                .focused(externalFocus ?? $internalFocus)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: SH.size.iconSM))
                        .foregroundStyle(theme.colors.textTertiary)
                }
                .buttonStyle(.shPressable(haptic: nil))
                .accessibilityLabel(Text("입력 지우기"))
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .frame(height: SH.size.controlMedium + 4)
        .background(background)
        .clipShape(theme.shape.control.shape)
        .overlay(border)
        .animation(theme.motion.quick, value: isFocused)
        .animation(theme.motion.quick, value: validation)
        .shDisabledAppearance()
    }

    @ViewBuilder
    private var field: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .shFont(\.bodyLarge)
        .foregroundStyle(theme.colors.textPrimary)
        .keyboardType(keyboardType)
        .textContentType(textContentType)
        .submitLabel(submitLabel)
        .onSubmit { onSubmit?() }
    }

    // MARK: Appearance

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .outlined: Color.clear
        case .filled:   theme.colors.surfaceSunken
        case .glass:    theme.shape.control.shape.fill(.ultraThinMaterial)
        }
    }

    private var border: some View {
        theme.shape.control.shape
            .stroke(borderColor, lineWidth: isFocused ? SH.size.borderEmphasis : SH.size.border)
    }

    private var borderColor: Color {
        if validation.isError { return theme.colors.error }
        if isFocused { return theme.colors.primaryText }
        if case .success = validation { return theme.colors.success }
        return variant == .glass ? theme.colors.glassBorder : theme.colors.border
    }

    private var accentColor: Color {
        if validation.isError { return theme.colors.error }
        if isFocused { return theme.colors.primaryText }
        return theme.colors.textSecondary
    }
}

// MARK: - SHTextArea

public struct SHTextArea: View {
    @Environment(\.shTheme) private var theme
    @FocusState private var internalFocus: Bool

    @Binding private var text: String

    private let placeholder: String
    private let variant: SHFieldVariant
    private let minHeight: CGFloat
    private let maxHeight: CGFloat
    private let characterLimit: Int?

    public init(
        _ placeholder: String,
        text: Binding<String>,
        variant: SHFieldVariant = .outlined,
        minHeight: CGFloat = 108,
        maxHeight: CGFloat = 220,
        characterLimit: Int? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.variant = variant
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.characterLimit = characterLimit
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: SH.spacing.xxs) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    SHText(placeholder, \.bodyLarge, role: .tertiary)
                        .padding(.horizontal, SH.spacing.md)
                        .padding(.vertical, SH.spacing.sm + 2)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $text)
                    .shFont(\.bodyLarge)
                    .foregroundStyle(theme.colors.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, SH.spacing.sm)
                    .padding(.vertical, SH.spacing.xs)
                    .focused($internalFocus)
            }
            .frame(minHeight: minHeight, maxHeight: maxHeight)
            .background(background)
            .clipShape(theme.shape.control.shape)
            .overlay(
                theme.shape.control.shape.stroke(
                    internalFocus ? theme.colors.primaryText : theme.colors.border,
                    lineWidth: internalFocus ? SH.size.borderEmphasis : SH.size.border
                )
            )

            if let characterLimit {
                SHText("\(text.count) / \(characterLimit)", \.caption,
                       role: text.count > characterLimit ? .status(.error) : .tertiary)
            }
        }
        .animation(theme.motion.quick, value: internalFocus)
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .outlined: Color.clear
        case .filled:   theme.colors.surfaceSunken
        case .glass:    theme.shape.control.shape.fill(.ultraThinMaterial)
        }
    }
}

// MARK: - Preview

#Preview("Field Variants") {
    ScrollView {
        VStack(spacing: SH.spacing.lg) {
            ForEach(SHFieldVariant.allCases, id: \.self) { variant in
                SHTextField(variant.displayName, text: .constant(""), variant: variant, icon: "magnifyingglass")
            }
            SHTextField("에러", text: .constant("잘못된 값"), validation: .error("형식을 확인해주세요"))
            SHTextField("성공", text: .constant("올바른 값"), validation: .success(nil))
            SHTextField("비활성", text: .constant("")).disabled(true)
            SHTextArea("자유롭게 적어주세요", text: .constant(""), characterLimit: 200)
        }
        .padding()
    }
    .background(SHThemeBackground())
    .shTheme(.lavender)
}
