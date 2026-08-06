import SwiftUI

// MARK: - Spacing
/// 간격은 앱마다 달라지지 않는 레이아웃 상수라 테마가 아니라 전역 스케일로 둔다.
public extension SH {
    enum spacing {
        /// 2pt
        public static let xxxs: CGFloat = 2
        /// 4pt
        public static let xxs: CGFloat = 4
        /// 8pt
        public static let xs: CGFloat = 8
        /// 12pt
        public static let sm: CGFloat = 12
        /// 16pt — 기본 간격
        public static let md: CGFloat = 16
        /// 20pt
        public static let lg: CGFloat = 20
        /// 24pt
        public static let xl: CGFloat = 24
        /// 32pt
        public static let xxl: CGFloat = 32
        /// 40pt
        public static let xxxl: CGFloat = 40
        /// 48pt — 섹션 구분
        public static let section: CGFloat = 48
        /// 64pt — 페이지 여백
        public static let page: CGFloat = 64
    }
}

public enum SHSpacingSize: Sendable, CaseIterable {
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

public extension View {
    func shPadding(_ size: SHSpacingSize = .md) -> some View {
        padding(size.value)
    }

    func shPadding(_ edges: Edge.Set, _ size: SHSpacingSize = .md) -> some View {
        padding(edges, size.value)
    }
}

// MARK: - Size
/// 컨트롤 높이·아이콘 크기·선 두께. 매직넘버가 컴포넌트로 새어나가지 않게 한다.
public extension SH {
    enum size {
        // 컨트롤 높이
        public static let controlSmall: CGFloat = 36
        public static let controlMedium: CGFloat = 48
        public static let controlLarge: CGFloat = 56

        // 아이콘
        public static let iconXS: CGFloat = 12
        public static let iconSM: CGFloat = 16
        public static let iconMD: CGFloat = 20
        public static let iconLG: CGFloat = 24
        public static let iconXL: CGFloat = 32
        public static let iconXXL: CGFloat = 48

        // 선
        public static let border: CGFloat = 1
        public static let borderEmphasis: CGFloat = 2
        public static let divider: CGFloat = 1

        /// HIG 최소 터치 영역.
        public static let minTapTarget: CGFloat = 44
    }
}

// MARK: - Control Size

public enum SHControlSize: String, Sendable, CaseIterable {
    case small, medium, large

    public var height: CGFloat {
        switch self {
        case .small: return SH.size.controlSmall
        case .medium: return SH.size.controlMedium
        case .large: return SH.size.controlLarge
        }
    }

    public var horizontalPadding: CGFloat {
        switch self {
        case .small: return SH.spacing.sm
        case .medium: return SH.spacing.lg
        case .large: return SH.spacing.xl
        }
    }

    public var iconSize: CGFloat {
        switch self {
        case .small: return SH.size.iconSM
        case .medium: return SH.size.iconMD
        case .large: return SH.size.iconLG
        }
    }

    public var font: KeyPath<SHTypographyScheme, SHFontToken> {
        switch self {
        case .small: return \.labelMedium
        case .medium: return \.labelLarge
        case .large: return \.titleSmall
        }
    }
}

// MARK: - Icon Size

public enum SHIconSize: Sendable, CaseIterable {
    case xs, sm, md, lg, xl, xxl

    public var value: CGFloat {
        switch self {
        case .xs: return SH.size.iconXS
        case .sm: return SH.size.iconSM
        case .md: return SH.size.iconMD
        case .lg: return SH.size.iconLG
        case .xl: return SH.size.iconXL
        case .xxl: return SH.size.iconXXL
        }
    }
}
