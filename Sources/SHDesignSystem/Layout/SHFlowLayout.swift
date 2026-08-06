import SwiftUI

// MARK: - SHFlowLayout
/// 가로로 채우다 넘치면 다음 줄로 흐르는 레이아웃.
/// 칩·태그 묶음처럼 항목 폭이 제각각인 곳에 쓴다.
///
/// `Layout` 프로토콜로 구현했기 때문에 Dynamic Type으로 글자가 커져도
/// 줄바꿈이 정확히 다시 계산된다.
public struct SHFlowLayout: Layout {
    public var spacing: CGFloat
    public var lineSpacing: CGFloat
    public var alignment: HorizontalAlignment

    public init(
        spacing: CGFloat = SH.spacing.xs,
        lineSpacing: CGFloat = SH.spacing.xs,
        alignment: HorizontalAlignment = .leading
    ) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
    }

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = layout(subviews: subviews, maxWidth: maxWidth)

        let height = rows.reduce(into: CGFloat.zero) { total, row in
            total += row.height
        } + lineSpacing * CGFloat(max(rows.count - 1, 0))

        let width = rows.map(\.width).max() ?? 0
        return CGSize(width: min(width, maxWidth), height: height)
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        let rows = layout(subviews: subviews, maxWidth: bounds.width)
        var y = bounds.minY

        for row in rows {
            var x = bounds.minX + leadingOffset(rowWidth: row.width, containerWidth: bounds.width)

            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(
                    at: CGPoint(x: x, y: y + (row.height - size.height) / 2),
                    proposal: ProposedViewSize(size)
                )
                x += size.width + spacing
            }
            y += row.height + lineSpacing
        }
    }

    // MARK: Row Computation

    private struct Row {
        var indices: [Int] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func layout(subviews: Subviews, maxWidth: CGFloat) -> [Row] {
        var rows: [Row] = []
        var current = Row()

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let additional = current.indices.isEmpty ? size.width : size.width + spacing

            if current.width + additional > maxWidth, !current.indices.isEmpty {
                rows.append(current)
                current = Row()
                current.indices = [index]
                current.width = size.width
                current.height = size.height
            } else {
                current.indices.append(index)
                current.width += additional
                current.height = max(current.height, size.height)
            }
        }

        if !current.indices.isEmpty { rows.append(current) }
        return rows
    }

    private func leadingOffset(rowWidth: CGFloat, containerWidth: CGFloat) -> CGFloat {
        switch alignment {
        case .center: return (containerWidth - rowWidth) / 2
        case .trailing: return containerWidth - rowWidth
        default: return 0
        }
    }
}
