import SwiftUI

// MARK: - SHDivider

public struct SHDivider: View {
    @Environment(\.shTheme) private var theme

    private let axis: Axis
    private let inset: CGFloat

    public init(_ axis: Axis = .horizontal, inset: CGFloat = 0) {
        self.axis = axis
        self.inset = inset
    }

    public var body: some View {
        Group {
            switch axis {
            case .horizontal:
                theme.colors.divider
                    .frame(height: SH.size.divider)
                    .padding(.horizontal, inset)
            case .vertical:
                theme.colors.divider
                    .frame(width: SH.size.divider)
                    .padding(.vertical, inset)
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - SHLabeledDivider

/// 가운데 라벨이 들어간 구분선. "또는" 같은 분기 지점에 쓴다.
public struct SHLabeledDivider: View {
    private let title: String

    public init(_ title: String) {
        self.title = title
    }

    public var body: some View {
        HStack(spacing: SH.spacing.sm) {
            SHDivider()
            SHText(title, \.labelMedium, role: .tertiary)
                .fixedSize()
            SHDivider()
        }
    }
}

// MARK: - Preview

#Preview("Dividers") {
    VStack(spacing: SH.spacing.lg) {
        SHDivider()
        SHLabeledDivider("또는")
        HStack {
            SHText("왼쪽")
            SHDivider(.vertical).frame(height: 24)
            SHText("오른쪽")
        }
    }
    .padding()
    .background(SHThemeBackground())
    .shTheme(.sky)
}
