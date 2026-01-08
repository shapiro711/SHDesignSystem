import SwiftUI

// MARK: - TextField Style
public enum SHTextFieldStyle: String, CaseIterable, Sendable {
    case outlined
    case filled
    case glass

    public var displayName: String {
        switch self {
        case .outlined: return "Outlined"
        case .filled: return "Filled"
        case .glass: return "Glass"
        }
    }
}

// MARK: - TextField State
public enum SHTextFieldState: Sendable {
    case normal
    case focused
    case error
    case success
    case disabled
}

// MARK: - SHTextField
public struct SHTextField: View {
    @Environment(\.shTheme) private var theme
    @FocusState private var isFocused: Bool

    @Binding private var text: String
    private let placeholder: String
    private let style: SHTextFieldStyle
    private let icon: String?
    private let isSecure: Bool
    private let state: SHTextFieldState
    private let onSubmit: (() -> Void)?

    public init(
        _ placeholder: String,
        text: Binding<String>,
        style: SHTextFieldStyle = .outlined,
        icon: String? = nil,
        isSecure: Bool = false,
        state: SHTextFieldState = .normal,
        onSubmit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.style = style
        self.icon = icon
        self.isSecure = isSecure
        self.state = state
        self.onSubmit = onSubmit
    }

    public var body: some View {
        HStack(spacing: SH.spacing.sm) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(iconColor)
            }

            textFieldView
        }
        .padding(.horizontal, SH.spacing.md)
        .frame(height: 52)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous))
        .overlay(overlayView)
        .focused($isFocused)
        .disabled(state == .disabled)
        .opacity(state == .disabled ? 0.5 : 1.0)
    }

    @ViewBuilder
    private var textFieldView: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .font(SH.typography.bodyMedium)
                .foregroundStyle(SH.colors.textPrimary)
                .onSubmit { onSubmit?() }
        } else {
            TextField(placeholder, text: $text)
                .font(SH.typography.bodyMedium)
                .foregroundStyle(SH.colors.textPrimary)
                .onSubmit { onSubmit?() }
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .outlined:
            Color.clear
        case .filled:
            SH.colors.surface
        case .glass:
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .fill(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
            .stroke(borderColor, lineWidth: borderWidth)
    }

    private var iconColor: Color {
        if isFocused {
            return theme.primaryColor
        }
        switch state {
        case .error:
            return SH.colors.error
        case .success:
            return SH.colors.success
        default:
            return SH.colors.textSecondary
        }
    }

    private var borderColor: Color {
        if isFocused {
            return theme.primaryColor
        }
        switch state {
        case .error:
            return SH.colors.error
        case .success:
            return SH.colors.success
        default:
            return style == .glass ? SH.colors.glassBorder : SH.colors.border
        }
    }

    private var borderWidth: CGFloat {
        isFocused ? 2 : 1
    }
}

// MARK: - Text Area (Multiline)
public struct SHTextArea: View {
    @Environment(\.shTheme) private var theme
    @FocusState private var isFocused: Bool

    @Binding private var text: String
    private let placeholder: String
    private let style: SHTextFieldStyle
    private let minHeight: CGFloat
    private let maxHeight: CGFloat

    public init(
        _ placeholder: String,
        text: Binding<String>,
        style: SHTextFieldStyle = .outlined,
        minHeight: CGFloat = 100,
        maxHeight: CGFloat = 200
    ) {
        self.placeholder = placeholder
        self._text = text
        self.style = style
        self.minHeight = minHeight
        self.maxHeight = maxHeight
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(SH.typography.bodyMedium)
                    .foregroundStyle(SH.colors.textTertiary)
                    .padding(.top, SH.spacing.md)
                    .padding(.leading, SH.spacing.md)
            }

            TextEditor(text: $text)
                .font(SH.typography.bodyMedium)
                .foregroundStyle(SH.colors.textPrimary)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, SH.spacing.sm)
                .padding(.vertical, SH.spacing.sm)
        }
        .frame(minHeight: minHeight, maxHeight: maxHeight)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .stroke(isFocused ? theme.primaryColor : SH.colors.border, lineWidth: isFocused ? 2 : 1)
        )
        .focused($isFocused)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .outlined:
            Color.clear
        case .filled:
            SH.colors.surface
        case .glass:
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .fill(.ultraThinMaterial)
        }
    }
}

// MARK: - Preview
#Preview("SHTextField Styles") {
    VStack(spacing: 20) {
        ForEach(SHTextFieldStyle.allCases, id: \.self) { style in
            SHTextField("플레이스홀더", text: .constant(""), style: style, icon: "magnifyingglass")
        }
    }
    .padding()
    .shTheme(.pastelLavender)
}

#Preview("SHTextField States") {
    VStack(spacing: 20) {
        SHTextField("일반", text: .constant("입력값"), state: .normal)
        SHTextField("에러", text: .constant("잘못된 값"), state: .error)
        SHTextField("성공", text: .constant("올바른 값"), state: .success)
        SHTextField("비활성", text: .constant(""), state: .disabled)
    }
    .padding()
    .shTheme(.pastelMint)
}
