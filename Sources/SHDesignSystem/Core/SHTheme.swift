import SwiftUI

// MARK: - Theme Definition
public enum SHTheme: String, CaseIterable, Sendable {
    case pastelPink
    case pastelMint
    case pastelLavender
    case pastelPeach
    case pastelSky
    case pastelLemon

    public var displayName: String {
        switch self {
        case .pastelPink: return "파스텔 핑크"
        case .pastelMint: return "파스텔 민트"
        case .pastelLavender: return "파스텔 라벤더"
        case .pastelPeach: return "파스텔 피치"
        case .pastelSky: return "파스텔 스카이"
        case .pastelLemon: return "파스텔 레몬"
        }
    }

    public var primaryColor: Color {
        switch self {
        case .pastelPink: return SH.colors.pink
        case .pastelMint: return SH.colors.mint
        case .pastelLavender: return SH.colors.lavender
        case .pastelPeach: return SH.colors.peach
        case .pastelSky: return SH.colors.sky
        case .pastelLemon: return SH.colors.lemon
        }
    }

    public var accentColor: Color {
        switch self {
        case .pastelPink: return SH.colors.lavender
        case .pastelMint: return SH.colors.pink
        case .pastelLavender: return SH.colors.mint
        case .pastelPeach: return SH.colors.sky
        case .pastelSky: return SH.colors.peach
        case .pastelLemon: return SH.colors.mint
        }
    }
}

// MARK: - Theme Environment Key
private struct SHThemeKey: EnvironmentKey {
    static let defaultValue: SHTheme = .pastelLavender
}

public extension EnvironmentValues {
    var shTheme: SHTheme {
        get { self[SHThemeKey.self] }
        set { self[SHThemeKey.self] = newValue }
    }
}

// MARK: - Theme Modifier
public extension View {
    func shTheme(_ theme: SHTheme) -> some View {
        self.environment(\.shTheme, theme)
    }
}

// MARK: - Theme Configuration (for custom themes)
public struct SHThemeConfiguration: Sendable {
    public let primary: Color
    public let secondary: Color
    public let accent: Color
    public let background: Color
    public let surface: Color

    public init(
        primary: Color,
        secondary: Color,
        accent: Color,
        background: Color,
        surface: Color
    ) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.background = background
        self.surface = surface
    }
}
