import SwiftUI

// MARK: - SH Color Palette
/// 파스텔톤 컬러 팔레트 (라이트/다크 모드 지원)
public extension SH {
    enum colors {
        // MARK: - Primary Pastels
        public static let pink = Color("SHPink", bundle: .module)
        public static let mint = Color("SHMint", bundle: .module)
        public static let lavender = Color("SHLavender", bundle: .module)
        public static let peach = Color("SHPeach", bundle: .module)
        public static let sky = Color("SHSky", bundle: .module)
        public static let lemon = Color("SHLemon", bundle: .module)

        // MARK: - Semantic Colors
        public static let primary = Color("SHPrimary", bundle: .module)
        public static let secondary = Color("SHSecondary", bundle: .module)
        public static let accent = Color("SHAccent", bundle: .module)

        // MARK: - Background Colors
        public static let background = Color("SHBackground", bundle: .module)
        public static let surface = Color("SHSurface", bundle: .module)
        public static let surfaceElevated = Color("SHSurfaceElevated", bundle: .module)

        // MARK: - Text Colors
        public static let textPrimary = Color("SHTextPrimary", bundle: .module)
        public static let textSecondary = Color("SHTextSecondary", bundle: .module)
        public static let textTertiary = Color("SHTextTertiary", bundle: .module)
        public static let textOnColor = Color("SHTextOnColor", bundle: .module)

        // MARK: - State Colors
        public static let success = Color("SHSuccess", bundle: .module)
        public static let warning = Color("SHWarning", bundle: .module)
        public static let error = Color("SHError", bundle: .module)
        public static let info = Color("SHInfo", bundle: .module)

        // MARK: - Border & Divider
        public static let border = Color("SHBorder", bundle: .module)
        public static let divider = Color("SHDivider", bundle: .module)

        // MARK: - Glass Effect Colors
        public static let glassBackground = Color("SHGlassBackground", bundle: .module)
        public static let glassBorder = Color("SHGlassBorder", bundle: .module)
    }
}

// MARK: - Programmatic Colors (Fallback)
/// Asset Catalog이 없을 때 사용할 폴백 컬러
public extension SH.colors {
    // MARK: - Pastel Raw Values
    enum raw {
        // Light Mode Pastels
        public static let pinkLight = Color(red: 1.0, green: 0.82, blue: 0.86)
        public static let pinkDark = Color(red: 0.95, green: 0.55, blue: 0.65)

        public static let mintLight = Color(red: 0.75, green: 0.95, blue: 0.90)
        public static let mintDark = Color(red: 0.45, green: 0.80, blue: 0.72)

        public static let lavenderLight = Color(red: 0.85, green: 0.80, blue: 0.95)
        public static let lavenderDark = Color(red: 0.65, green: 0.55, blue: 0.85)

        public static let peachLight = Color(red: 1.0, green: 0.87, blue: 0.77)
        public static let peachDark = Color(red: 0.95, green: 0.65, blue: 0.50)

        public static let skyLight = Color(red: 0.75, green: 0.88, blue: 1.0)
        public static let skyDark = Color(red: 0.50, green: 0.70, blue: 0.95)

        public static let lemonLight = Color(red: 1.0, green: 0.97, blue: 0.75)
        public static let lemonDark = Color(red: 0.95, green: 0.85, blue: 0.45)
    }
}

// MARK: - Adaptive Color Helper
public extension Color {
    /// 라이트/다크 모드에 따라 다른 색상을 반환
    static func shAdaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}
