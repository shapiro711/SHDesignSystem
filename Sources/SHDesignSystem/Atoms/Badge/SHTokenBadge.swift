import SwiftUI

// MARK: - SHTokenBadge

/// 짧은 라벨을 색면 위에 얹는 배지. **색만 밖에서 받는다.**
///
/// `SHBadge`·`SHTag`는 색을 테마 상태(`SHStatusKind`)에서 꺼내 쓴다. 그래서 앱이
/// **데이터로 소유한 색**은 그리지 못한다 — 사용자가 고른 근무 유형 색, 카테고리 색,
/// 캘린더 색처럼 테마 색조를 바꿔도 따라 변하면 안 되는 값들이다.
/// 그런 자리를 앱마다 인라인으로 다시 만들지 않도록 여기서 흡수한다.
///
/// 색을 제외한 나머지(타이포·간격·모양·Dynamic Type·최소 대비 확보 책임의 경계)는
/// 전부 토큰을 따른다. 색 두 개의 대비를 맞추는 건 **넘기는 쪽 책임**이다 —
/// `SHColorMath.contrastRatio(_:_:)`로 검증할 수 있다.
///
/// ```swift
/// SHTokenBadge(
///     "N",
///     foreground: myPalette.ink,
///     container: myPalette.container,
///     size: .md,
///     layout: .tile
/// )
/// ```
public struct SHTokenBadge: View {
    @Environment(\.shTheme) private var theme

    /// 크기 토큰이 Dynamic Type을 따라 함께 커지게 하는 배율.
    /// 글자만 커지고 색면이 고정이면 큰 글자 설정에서 라벨이 잘린다.
    @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1

    private let text: String
    private let foreground: Color
    private let container: Color
    private let size: Size
    private let layout: Layout
    private let isMuted: Bool
    private let overriddenAccessibilityLabel: String?

    /// 후퇴시킬 때 쓰는 불투명도. "덜 중요함"을 색이 아니라 밀도로 표현한다.
    public static let mutedOpacity: Double = 0.55

    public init(
        _ text: String,
        foreground: Color,
        container: Color,
        size: Size = .md,
        layout: Layout = .pill,
        isMuted: Bool = false,
        accessibilityLabel: String? = nil
    ) {
        self.text = text
        self.foreground = foreground
        self.container = container
        self.size = size
        self.layout = layout
        self.isMuted = isMuted
        self.overriddenAccessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        Text(text)
            .shFont(font, design: theme.typography.design)
            .foregroundStyle(foreground)
            .lineLimit(1)
            // 2자 약칭이 큰 글자 설정에서 잘리는 것보다 조금 줄어드는 편이 낫다
            .minimumScaleFactor(0.6)
            .modifier(FrameModifier(layout: layout, size: size, scale: scale))
            .background(container)
            .clipShape(shape)
            .opacity(isMuted ? Self.mutedOpacity : 1)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(overriddenAccessibilityLabel ?? text))
    }

    // MARK: - 파생값

    /// 테마 타이포 토큰에서 굵기만 bold로 바꿔 쓴다.
    /// 크기·스케일 기준은 토큰 그대로라 Dynamic Type을 그대로 따른다.
    /// 행간은 1로 눌러 둔다 — 한 줄짜리 색면에 본문 행간이 붙으면 위아래가 뜬다.
    private var font: SHFontToken {
        let base = theme.typography[keyPath: size.font]
        return SHFontToken(
            size: base.size,
            weight: .bold,
            relativeTo: base.relativeTo,
            lineHeight: 1,
            tracking: base.tracking
        )
    }

    private var shape: AnyShape {
        switch layout {
        case .pill:
            return theme.shape.badge.shape
        case .tile, .wide:
            return theme.shape.thumbnail.shape
        }
    }
}

// MARK: - Size

public extension SHTokenBadge {
    enum Size: Sendable, CaseIterable {
        /// 격자 셀, 조밀한 목록 행
        case sm
        /// 일반 목록 행
        case md
        /// 미리보기 열
        case lg
        /// 화면의 주인공 자리
        case xl

        var font: KeyPath<SHTypographyScheme, SHFontToken> {
            switch self {
            case .sm: return \.labelMedium      // 13
            case .md: return \.labelLarge       // 15
            case .lg: return \.titleSmall       // 16
            case .xl: return \.headlineSmall    // 22
            }
        }

        /// `.tile`의 한 변
        var side: CGFloat {
            switch self {
            case .sm: return SH.size.iconXL          // 32
            case .md: return SH.size.controlSmall    // 36
            case .lg: return 40
            case .xl: return SH.size.controlMedium   // 48
            }
        }

        /// `.pill`이 한 글자짜리 약칭에서도 무너지지 않게 잡는 최소 폭
        var minWidth: CGFloat {
            switch self {
            case .sm: return 26
            case .md: return 30
            case .lg: return 34
            case .xl: return 40
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .sm, .md: return SH.spacing.xs
            case .lg, .xl: return SH.spacing.sm
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .sm: return SH.spacing.xxxs
            case .md, .lg: return SH.spacing.xxs
            case .xl: return SH.spacing.xs
            }
        }
    }
}

// MARK: - Layout

public extension SHTokenBadge {
    enum Layout: Sendable {
        /// 캡슐. 글자 폭에 맞춰 줄고 늘어난다.
        case pill
        /// 정사각 타일. 목록 행 앞머리처럼 열을 맞춰야 하는 자리.
        case tile
        /// 가로를 채우는 타일. 균등 분할된 미리보기 열.
        case wide
    }
}

// MARK: - Frame

/// `@ScaledMetric`은 뷰에 있어야 반응하므로 배율을 받아서 적용만 한다.
private struct FrameModifier: ViewModifier {
    let layout: SHTokenBadge.Layout
    let size: SHTokenBadge.Size
    let scale: CGFloat

    func body(content: Content) -> some View {
        switch layout {
        case .pill:
            content
                .padding(.horizontal, size.horizontalPadding)
                .padding(.vertical, size.verticalPadding)
                .frame(minWidth: size.minWidth * scale)

        case .tile:
            content
                .frame(width: size.side * scale, height: size.side * scale)

        case .wide:
            content
                .padding(.vertical, size.verticalPadding)
                .frame(maxWidth: .infinity, minHeight: size.side * scale)
        }
    }
}

// MARK: - Preview

#Preview("TokenBadge") {
    // 앱이 소유한 색이라고 가정한 값들
    let ink = Color(hue: 0.58, saturation: 0.85, brightness: 0.52)
    let container = Color(hue: 0.58, saturation: 0.18, brightness: 0.97)

    return VStack(spacing: SH.spacing.xl) {
        HStack(spacing: SH.spacing.sm) {
            ForEach(SHTokenBadge.Size.allCases, id: \.self) { size in
                SHTokenBadge("N", foreground: ink, container: container, size: size)
            }
        }

        HStack(spacing: SH.spacing.sm) {
            ForEach(SHTokenBadge.Size.allCases, id: \.self) { size in
                SHTokenBadge("D", foreground: ink, container: container,
                             size: size, layout: .tile)
            }
        }

        HStack(spacing: SH.spacing.xs) {
            ForEach(0..<5, id: \.self) { _ in
                SHTokenBadge("야", foreground: ink, container: container,
                             size: .lg, layout: .wide)
            }
        }

        HStack(spacing: SH.spacing.sm) {
            SHTokenBadge("휴", foreground: ink, container: container, layout: .tile)
            SHTokenBadge("휴", foreground: ink, container: container,
                         layout: .tile, isMuted: true)
        }
    }
    .padding()
    .background(SHThemeBackground())
    .shTheme(.sky)
}
