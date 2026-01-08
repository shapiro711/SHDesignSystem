import SwiftUI

// MARK: - Spacing Tokens
public extension SH {
    enum spacing {
        /// 2pt - 극소 간격
        public static let xxxs: CGFloat = 2

        /// 4pt - 매우 작은 간격
        public static let xxs: CGFloat = 4

        /// 8pt - 작은 간격
        public static let xs: CGFloat = 8

        /// 12pt - 소형 간격
        public static let sm: CGFloat = 12

        /// 16pt - 기본 간격
        public static let md: CGFloat = 16

        /// 20pt - 중간 간격
        public static let lg: CGFloat = 20

        /// 24pt - 큰 간격
        public static let xl: CGFloat = 24

        /// 32pt - 매우 큰 간격
        public static let xxl: CGFloat = 32

        /// 40pt - 극대 간격
        public static let xxxl: CGFloat = 40

        /// 48pt - 섹션 간격
        public static let section: CGFloat = 48

        /// 64pt - 페이지 간격
        public static let page: CGFloat = 64
    }
}

// MARK: - Spacing Style Enum
public enum SHSpacingSize {
    case xxxs, xxs, xs, sm, md, lg, xl, xxl, xxxl, section, page

    public var value: CGFloat {
        switch self {
        case .xxxs: return SH.spacing.xxxs
        case .xxs: return SH.spacing.xxs
        case .xs: return SH.spacing.xs
        case .sm: return SH.spacing.sm
        case .md: return SH.spacing.md
        case .lg: return SH.spacing.lg
        case .xl: return SH.spacing.xl
        case .xxl: return SH.spacing.xxl
        case .xxxl: return SH.spacing.xxxl
        case .section: return SH.spacing.section
        case .page: return SH.spacing.page
        }
    }
}

// MARK: - View Extensions
public extension View {
    func shPadding(_ size: SHSpacingSize) -> some View {
        self.padding(size.value)
    }

    func shPadding(_ edges: Edge.Set, _ size: SHSpacingSize) -> some View {
        self.padding(edges, size.value)
    }

    func shSpacing(_ size: SHSpacingSize) -> some View {
        self.padding(size.value)
    }
}
