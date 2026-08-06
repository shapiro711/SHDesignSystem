import SwiftUI

// MARK: - SHSearchBar

public struct SHSearchBar: View {
    @Environment(\.shTheme) private var theme
    @FocusState private var internalFocus: Bool

    @Binding private var text: String

    private let placeholder: String
    private let variant: SHFieldVariant
    private let showsCancelButton: Bool
    private let cancelTitle: String
    private let focus: FocusState<Bool>.Binding?
    private let onSubmit: (() -> Void)?
    private let onCancel: (() -> Void)?

    public init(
        _ placeholder: String = "검색",
        text: Binding<String>,
        variant: SHFieldVariant = .filled,
        showsCancelButton: Bool = true,
        cancelTitle: String = "취소",
        focus: FocusState<Bool>.Binding? = nil,
        onSubmit: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.variant = variant
        self.showsCancelButton = showsCancelButton
        self.cancelTitle = cancelTitle
        self.focus = focus
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }

    private var isFocused: Bool { focus?.wrappedValue ?? internalFocus }
    private var showsCancel: Bool { showsCancelButton && (isFocused || !text.isEmpty) }

    public var body: some View {
        HStack(spacing: SH.spacing.sm) {
            field

            if showsCancel {
                Button(cancelTitle) {
                    text = ""
                    if let focus { focus.wrappedValue = false } else { internalFocus = false }
                    onCancel?()
                }
                .shFont(\.bodyMedium)
                .foregroundStyle(theme.colors.primaryText)
                .buttonStyle(.shPressable(haptic: nil))
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(theme.motion.standard, value: showsCancel)
    }

    private var field: some View {
        HStack(spacing: SH.spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: SH.size.iconSM, weight: .semibold))
                .foregroundStyle(isFocused ? theme.colors.primaryText : theme.colors.textSecondary)
                .accessibilityHidden(true)

            TextField(placeholder, text: $text)
                .shFont(\.bodyMedium)
                .foregroundStyle(theme.colors.textPrimary)
                .submitLabel(.search)
                .focused(focus ?? $internalFocus)
                .onSubmit { onSubmit?() }
                .accessibilityLabel(Text(placeholder))

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: SH.size.iconSM))
                        .foregroundStyle(theme.colors.textTertiary)
                }
                .buttonStyle(.shPressable(haptic: nil))
                .accessibilityLabel(Text("검색어 지우기"))
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .frame(height: SH.size.minTapTarget)
        .background(background)
        .clipShape(theme.shape.chip.shape)
        .overlay(border)
        .animation(theme.motion.quick, value: isFocused)
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .outlined: Color.clear
        case .filled:   theme.colors.surfaceSunken
        case .glass:    theme.shape.chip.shape.fill(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    private var border: some View {
        switch variant {
        case .outlined:
            theme.shape.chip.shape.stroke(
                isFocused ? theme.colors.primaryText : theme.colors.border,
                lineWidth: isFocused ? SH.size.borderEmphasis : SH.size.border
            )
        case .glass:
            theme.shape.chip.shape.stroke(theme.colors.glassBorder, lineWidth: SH.size.border)
        case .filled:
            EmptyView()
        }
    }
}

// MARK: - Preview

#Preview("SHSearchBar") {
    VStack(spacing: SH.spacing.lg) {
        ForEach(SHFieldVariant.allCases, id: \.self) { variant in
            SHSearchBar(text: .constant(""), variant: variant)
        }
        SHSearchBar(text: .constant("몽글"))
    }
    .padding()
    .background(SHThemeBackground())
    .shTheme(.mint)
}
