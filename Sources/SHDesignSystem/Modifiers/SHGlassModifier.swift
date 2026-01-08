import SwiftUI

// MARK: - Glass Style
public enum SHGlassStyle: Sendable {
    case ultraThin
    case thin
    case regular
    case thick
    case ultraThick

    var material: Material {
        switch self {
        case .ultraThin: return .ultraThinMaterial
        case .thin: return .thinMaterial
        case .regular: return .regularMaterial
        case .thick: return .thickMaterial
        case .ultraThick: return .ultraThickMaterial
        }
    }
}

// MARK: - Glass Modifier
public struct SHGlassModifier: ViewModifier {
    private let style: SHGlassStyle
    private let cornerRadius: CGFloat
    private let showBorder: Bool

    public init(
        style: SHGlassStyle = .regular,
        cornerRadius: CGFloat = SH.radius.xl,
        showBorder: Bool = true
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.showBorder = showBorder
    }

    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(style.material)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                Group {
                    if showBorder {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(SH.colors.glassBorder, lineWidth: 1)
                    }
                }
            )
    }
}

// MARK: - View Extension
public extension View {
    func shGlass(
        style: SHGlassStyle = .regular,
        cornerRadius: CGFloat = SH.radius.xl,
        showBorder: Bool = true
    ) -> some View {
        self.modifier(
            SHGlassModifier(
                style: style,
                cornerRadius: cornerRadius,
                showBorder: showBorder
            )
        )
    }

    func shGlassCard(style: SHGlassStyle = .regular) -> some View {
        self
            .padding(SH.spacing.md)
            .shGlass(style: style, cornerRadius: SH.radius.xxl)
    }
}

// MARK: - Preview
#Preview("Glass Styles") {
    ZStack {
        LinearGradient(
            colors: [SH.colors.pink, SH.colors.lavender, SH.colors.mint],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 20) {
            Text("Ultra Thin")
                .padding()
                .shGlass(style: .ultraThin)

            Text("Regular")
                .padding()
                .shGlass(style: .regular)

            Text("Ultra Thick")
                .padding()
                .shGlass(style: .ultraThick)
        }
    }
}
