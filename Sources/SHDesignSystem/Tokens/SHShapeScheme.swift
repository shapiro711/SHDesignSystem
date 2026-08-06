import SwiftUI

// MARK: - Corner Style

public enum SHCornerStyle: Sendable, Equatable {
    case capsule
    case rounded(CGFloat)

    /// 실제 반경. 캡슐은 컨테이너 높이에 따라 결정되므로 여기선 근사값만 쓴다.
    public func radius(for height: CGFloat) -> CGFloat {
        switch self {
        case .capsule: return height / 2
        case .rounded(let value): return value
        }
    }

    public var shape: AnyShape {
        switch self {
        case .capsule:
            return AnyShape(Capsule(style: .continuous))
        case .rounded(let value):
            return AnyShape(RoundedRectangle(cornerRadius: value, style: .continuous))
        }
    }
}

// MARK: - Shape Scheme
/// 컴포넌트별 모양 토큰. 컴포넌트가 `SH.radius.xl` 같은 스케일 값을
/// 직접 고르면 앱마다 각지게/둥글게 바꿀 수 없으므로, 반드시 역할로 참조한다.
public struct SHShapeScheme: Sendable {
    public let button: SHCornerStyle
    public let control: SHCornerStyle      // TextField, SearchBar, Stepper …
    public let card: SHCornerStyle
    public let container: SHCornerStyle    // 그룹 박스, 섹션 배경
    public let sheet: SHCornerStyle
    public let chip: SHCornerStyle
    public let thumbnail: SHCornerStyle
    public let badge: SHCornerStyle

    public init(
        button: SHCornerStyle,
        control: SHCornerStyle,
        card: SHCornerStyle,
        container: SHCornerStyle,
        sheet: SHCornerStyle,
        chip: SHCornerStyle,
        thumbnail: SHCornerStyle,
        badge: SHCornerStyle
    ) {
        self.button = button
        self.control = control
        self.card = card
        self.container = container
        self.sheet = sheet
        self.chip = chip
        self.thumbnail = thumbnail
        self.badge = badge
    }

    /// SH 시그니처. 넉넉한 라운딩이 "몽글몽글"의 핵심이다.
    public static let signature = SHShapeScheme(
        button: .rounded(18),
        control: .rounded(16),
        card: .rounded(24),
        container: .rounded(20),
        sheet: .rounded(32),
        chip: .capsule,
        thumbnail: .rounded(14),
        badge: .capsule
    )
}

// MARK: - Radius Scale
/// 역할 토큰으로 못 덮는 자리에서만 쓰는 원시 스케일.
public extension SH {
    enum radius {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 20
        public static let xxl: CGFloat = 24
        public static let xxxl: CGFloat = 32
    }
}
