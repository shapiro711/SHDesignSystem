import SwiftUI

// MARK: - Glass Style

public enum SHGlassStyle: Sendable, CaseIterable {
    case ultraThin
    case thin
    case regular
    case thick

    var material: Material {
        switch self {
        case .ultraThin: return .ultraThinMaterial
        case .thin: return .thinMaterial
        case .regular: return .regularMaterial
        case .thick: return .thickMaterial
        }
    }
}

// MARK: - Glass Modifier

struct SHGlassModifier: ViewModifier {
    @Environment(\.shTheme) private var theme

    let style: SHGlassStyle
    let shape: SHCornerStyle
    let showsBorder: Bool

    func body(content: Content) -> some View {
        content
            .background(shape.shape.fill(style.material))
            .clipShape(shape.shape)
            .overlay {
                if showsBorder {
                    shape.shape.stroke(theme.colors.glassBorder, lineWidth: SH.size.border)
                }
            }
    }
}

public extension View {
    func shGlass(
        _ style: SHGlassStyle = .regular,
        shape: SHCornerStyle = .rounded(SH.radius.xl),
        showsBorder: Bool = true
    ) -> some View {
        modifier(SHGlassModifier(style: style, shape: shape, showsBorder: showsBorder))
    }
}
