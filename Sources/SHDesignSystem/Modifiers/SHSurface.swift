import SwiftUI

// MARK: - Surface Role
/// 배경·테두리·깊이를 한 덩어리로 묶은 표면 역할.
/// 컴포넌트가 배경색과 테두리를 각자 조합하면 조합 폭발이 나므로
/// 표면은 반드시 역할 하나로 지정한다.
public enum SHSurfaceRole: Sendable, Equatable {
    /// 배경과 같은 층. 테두리 없음.
    case plain
    /// 카드 기본. 표면색 + 옅은 그림자.
    case elevated
    /// 표면색 + 테두리. 그림자 없음.
    case outlined
    /// 브랜드 파스텔 틴트.
    case tinted
    /// 반투명 유리.
    case glass
    /// 상태색 컨테이너.
    case status(SHStatusKind)
}

public enum SHStatusKind: String, Sendable, CaseIterable {
    case success, warning, error, info
}

// MARK: - Surface Modifier

struct SHSurfaceModifier: ViewModifier {
    @Environment(\.shTheme) private var theme

    let role: SHSurfaceRole
    let shape: SHCornerStyle

    func body(content: Content) -> some View {
        content
            .background(background)
            .clipShape(shape.shape)
            .overlay(border)
            .shShadow(shadow)
    }

    @ViewBuilder
    private var background: some View {
        switch role {
        case .plain:
            Color.clear
        case .elevated, .outlined:
            theme.colors.surface
        case .tinted:
            theme.colors.primaryContainer
        case .glass:
            shape.shape.fill(.ultraThinMaterial)
        case .status(let kind):
            theme.colors.container(for: kind)
        }
    }

    @ViewBuilder
    private var border: some View {
        switch role {
        case .outlined:
            shape.shape.stroke(theme.colors.border, lineWidth: SH.size.border)
        case .glass:
            shape.shape.stroke(theme.colors.glassBorder, lineWidth: SH.size.border)
        case .plain, .elevated, .tinted, .status:
            EmptyView()
        }
    }

    private var shadow: SHShadowToken {
        switch role {
        case .elevated: return theme.elevation.raised
        default: return .none
        }
    }
}

public extension View {
    /// 표면 역할과 모양을 한 번에 적용한다.
    func shSurface(_ role: SHSurfaceRole, shape: SHCornerStyle) -> some View {
        modifier(SHSurfaceModifier(role: role, shape: shape))
    }
}

// MARK: - Status Color Lookup

public extension SHColorScheme {
    func fill(for kind: SHStatusKind) -> Color {
        switch kind {
        case .success: return success
        case .warning: return warning
        case .error: return error
        case .info: return info
        }
    }

    func onFill(for kind: SHStatusKind) -> Color {
        switch kind {
        case .success: return onSuccess
        case .warning: return onWarning
        case .error: return onError
        case .info: return onInfo
        }
    }

    func container(for kind: SHStatusKind) -> Color {
        switch kind {
        case .success: return successContainer
        case .warning: return warningContainer
        case .error: return errorContainer
        case .info: return infoContainer
        }
    }

    func onContainer(for kind: SHStatusKind) -> Color {
        switch kind {
        case .success: return onSuccessContainer
        case .warning: return onWarningContainer
        case .error: return onErrorContainer
        case .info: return onInfoContainer
        }
    }
}
