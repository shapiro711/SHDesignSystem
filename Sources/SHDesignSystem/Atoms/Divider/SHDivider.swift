import SwiftUI

// MARK: - Divider Style
public enum SHDividerStyle: Sendable {
    case solid
    case dashed
    case dotted
}

// MARK: - Divider Orientation
public enum SHDividerOrientation: Sendable {
    case horizontal
    case vertical
}

// MARK: - SHDivider
public struct SHDivider: View {
    private let style: SHDividerStyle
    private let orientation: SHDividerOrientation
    private let thickness: CGFloat
    private let color: Color

    public init(
        style: SHDividerStyle = .solid,
        orientation: SHDividerOrientation = .horizontal,
        thickness: CGFloat = 1,
        color: Color = SH.colors.divider
    ) {
        self.style = style
        self.orientation = orientation
        self.thickness = thickness
        self.color = color
    }

    public var body: some View {
        switch orientation {
        case .horizontal:
            horizontalDivider
        case .vertical:
            verticalDivider
        }
    }

    @ViewBuilder
    private var horizontalDivider: some View {
        switch style {
        case .solid:
            Rectangle()
                .fill(color)
                .frame(height: thickness)
        case .dashed:
            dashedLine(isHorizontal: true)
        case .dotted:
            dottedLine(isHorizontal: true)
        }
    }

    @ViewBuilder
    private var verticalDivider: some View {
        switch style {
        case .solid:
            Rectangle()
                .fill(color)
                .frame(width: thickness)
        case .dashed:
            dashedLine(isHorizontal: false)
        case .dotted:
            dottedLine(isHorizontal: false)
        }
    }

    private func dashedLine(isHorizontal: Bool) -> some View {
        GeometryReader { geometry in
            Path { path in
                if isHorizontal {
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                } else {
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: thickness, dash: [6, 4]))
        }
        .frame(
            width: isHorizontal ? nil : thickness,
            height: isHorizontal ? thickness : nil
        )
    }

    private func dottedLine(isHorizontal: Bool) -> some View {
        GeometryReader { geometry in
            Path { path in
                if isHorizontal {
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                } else {
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: thickness, lineCap: .round, dash: [2, 4]))
        }
        .frame(
            width: isHorizontal ? nil : thickness,
            height: isHorizontal ? thickness : nil
        )
    }
}

// MARK: - Labeled Divider
public struct SHLabeledDivider: View {
    @Environment(\.shTheme) private var theme

    private let label: String
    private let color: Color

    public init(_ label: String, color: Color = SH.colors.divider) {
        self.label = label
        self.color = color
    }

    public var body: some View {
        HStack(spacing: SH.spacing.md) {
            SHDivider(color: color)
            Text(label)
                .font(SH.typography.caption)
                .foregroundStyle(SH.colors.textTertiary)
            SHDivider(color: color)
        }
    }
}

// MARK: - Preview
#Preview("SHDivider Styles") {
    VStack(spacing: 30) {
        VStack(alignment: .leading, spacing: 8) {
            Text("Solid")
                .font(.caption)
            SHDivider(style: .solid)
        }

        VStack(alignment: .leading, spacing: 8) {
            Text("Dashed")
                .font(.caption)
            SHDivider(style: .dashed)
                .frame(height: 1)
        }

        VStack(alignment: .leading, spacing: 8) {
            Text("Dotted")
                .font(.caption)
            SHDivider(style: .dotted)
                .frame(height: 1)
        }

        SHLabeledDivider("또는")
    }
    .padding()
}

#Preview("Vertical Divider") {
    HStack(spacing: 20) {
        Text("왼쪽")
        SHDivider(orientation: .vertical)
            .frame(height: 30)
        Text("오른쪽")
    }
    .padding()
}
