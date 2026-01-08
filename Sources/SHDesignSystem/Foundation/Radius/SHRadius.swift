import SwiftUI

// MARK: - Radius Tokens (몽글몽글 디자인)
public extension SH {
    enum radius {
        /// 4pt - 미세한 라운딩
        public static let xs: CGFloat = 4

        /// 8pt - 작은 라운딩
        public static let sm: CGFloat = 8

        /// 12pt - 기본 라운딩
        public static let md: CGFloat = 12

        /// 16pt - 중간 라운딩
        public static let lg: CGFloat = 16

        /// 20pt - 큰 라운딩
        public static let xl: CGFloat = 20

        /// 24pt - 매우 큰 라운딩
        public static let xxl: CGFloat = 24

        /// 32pt - 극대 라운딩 (카드, 모달)
        public static let xxxl: CGFloat = 32

        /// 원형
        public static let full: CGFloat = 9999
    }
}

// MARK: - Radius Style Enum
public enum SHRadiusSize {
    case xs, sm, md, lg, xl, xxl, xxxl, full

    public var value: CGFloat {
        switch self {
        case .xs: return SH.radius.xs
        case .sm: return SH.radius.sm
        case .md: return SH.radius.md
        case .lg: return SH.radius.lg
        case .xl: return SH.radius.xl
        case .xxl: return SH.radius.xxl
        case .xxxl: return SH.radius.xxxl
        case .full: return SH.radius.full
        }
    }
}

// MARK: - View Extension
public extension View {
    func shCornerRadius(_ size: SHRadiusSize) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: size.value, style: .continuous))
    }
}

// MARK: - Rounded Rectangle Helper
public extension RoundedRectangle {
    static func sh(_ size: SHRadiusSize) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: size.value, style: .continuous)
    }
}
