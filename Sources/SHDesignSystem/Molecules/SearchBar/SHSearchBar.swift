import SwiftUI

// MARK: - SearchBar Style
public enum SHSearchBarStyle: String, CaseIterable, Sendable {
    case standard
    case glass
    case filled

    public var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .glass: return "Glass"
        case .filled: return "Filled"
        }
    }
}

// MARK: - SHSearchBar
public struct SHSearchBar: View {
    @Environment(\.shTheme) private var theme
    @FocusState private var isFocused: Bool

    @Binding private var text: String
    private let placeholder: String
    private let style: SHSearchBarStyle
    private let showsCancelButton: Bool
    private let onSubmit: (() -> Void)?
    private let onCancel: (() -> Void)?

    public init(
        _ placeholder: String = "검색",
        text: Binding<String>,
        style: SHSearchBarStyle = .standard,
        showsCancelButton: Bool = true,
        onSubmit: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.style = style
        self.showsCancelButton = showsCancelButton
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }

    public var body: some View {
        HStack(spacing: SH.spacing.sm) {
            searchField

            if showsCancelButton && (isFocused || !text.isEmpty) {
                Button("취소") {
                    text = ""
                    isFocused = false
                    onCancel?()
                }
                .font(SH.typography.bodyMedium)
                .foregroundStyle(theme.primaryColor)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }

    private var searchField: some View {
        HStack(spacing: SH.spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(isFocused ? theme.primaryColor : SH.colors.textSecondary)

            TextField(placeholder, text: $text)
                .font(SH.typography.bodyMedium)
                .foregroundStyle(SH.colors.textPrimary)
                .focused($isFocused)
                .onSubmit { onSubmit?() }

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(SH.colors.textTertiary)
                }
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .frame(height: 44)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous))
        .overlay(overlayView)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .standard:
            SH.colors.surface
        case .glass:
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .fill(.ultraThinMaterial)
        case .filled:
            theme.primaryColor.opacity(0.1)
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        switch style {
        case .standard:
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .stroke(isFocused ? theme.primaryColor : SH.colors.border, lineWidth: isFocused ? 2 : 1)
        case .glass:
            RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous)
                .stroke(SH.colors.glassBorder, lineWidth: 1)
        case .filled:
            EmptyView()
        }
    }
}

// MARK: - Preview
#Preview("SHSearchBar Styles") {
    VStack(spacing: 24) {
        ForEach(SHSearchBarStyle.allCases, id: \.self) { style in
            VStack(alignment: .leading, spacing: 8) {
                Text(style.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                SHSearchBar(text: .constant(""), style: style)
            }
        }

        SHSearchBar(text: .constant("검색어"))
    }
    .padding()
    .shTheme(.pastelMint)
}
