import SwiftUI

// MARK: - Shimmer

private struct SHShimmerModifier: ViewModifier {
    @Environment(\.shTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay {
                if !reduceMotion {
                    GeometryReader { proxy in
                        LinearGradient(
                            colors: [
                                .clear,
                                theme.colors.surface.opacity(0.55),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: proxy.size.width * 0.6)
                        .offset(x: phase * proxy.size.width * 1.6)
                    }
                    .allowsHitTesting(false)
                }
            }
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.linear(duration: 1.3).repeatForever(autoreverses: false)) {
                    phase = 1.2
                }
            }
    }
}

// MARK: - SHSkeleton

/// 콘텐츠 자리를 잡아주는 로딩 플레이스홀더.
/// 스피너보다 체감 대기시간이 짧고 레이아웃 점프가 없다.
public struct SHSkeleton: View {
    @Environment(\.shTheme) private var theme

    private let width: CGFloat?
    private let height: CGFloat
    private let shape: SHCornerStyle

    public init(width: CGFloat? = nil, height: CGFloat = 16, shape: SHCornerStyle = .rounded(SH.radius.sm)) {
        self.width = width
        self.height = height
        self.shape = shape
    }

    public var body: some View {
        shape.shape
            .fill(theme.colors.surfaceSunken)
            .frame(width: width, height: height)
            .modifier(SHShimmerModifier())
            .accessibilityHidden(true)
    }
}

// MARK: - Presets

public extension SHSkeleton {
    /// 텍스트 한 줄.
    static func line(width: CGFloat? = nil) -> SHSkeleton {
        SHSkeleton(width: width, height: 14, shape: .capsule)
    }

    /// 원형 아바타.
    static func circle(_ diameter: CGFloat = 44) -> SHSkeleton {
        SHSkeleton(width: diameter, height: diameter, shape: .capsule)
    }
}

/// 문단 형태의 스켈레톤. 마지막 줄만 짧게 해서 실제 글처럼 보이게 한다.
public struct SHSkeletonParagraph: View {
    private let lines: Int

    public init(lines: Int = 3) {
        self.lines = lines
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SH.spacing.xs) {
            ForEach(0..<lines, id: \.self) { index in
                SHSkeleton.line()
                    .frame(maxWidth: index == lines - 1 ? 160 : .infinity)
            }
        }
        .accessibilityHidden(true)
    }
}

/// 리스트 로딩용 행 스켈레톤.
public struct SHSkeletonRow: View {
    private let showsLeading: Bool

    public init(showsLeading: Bool = true) {
        self.showsLeading = showsLeading
    }

    public var body: some View {
        HStack(spacing: SH.spacing.md) {
            if showsLeading {
                SHSkeleton.circle(40)
            }
            VStack(alignment: .leading, spacing: SH.spacing.xs) {
                SHSkeleton.line()
                SHSkeleton.line().frame(maxWidth: 120)
            }
        }
        .padding(.horizontal, SH.spacing.md)
        .padding(.vertical, SH.spacing.sm)
        .accessibilityHidden(true)
    }
}

// MARK: - Preview

#Preview("Skeleton") {
    VStack(alignment: .leading, spacing: SH.spacing.lg) {
        ForEach(0..<4, id: \.self) { _ in SHSkeletonRow() }
        SHSkeletonParagraph()
            .padding(.horizontal, SH.spacing.md)
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.vertical)
    .background(SHThemeBackground())
    .shTheme(.mint)
}
