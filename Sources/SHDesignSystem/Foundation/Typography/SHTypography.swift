import SwiftUI

// MARK: - Typography Tokens
public extension SH {
    enum typography {
        // MARK: - Display
        public static let displayLarge = Font.system(size: 57, weight: .bold, design: .rounded)
        public static let displayMedium = Font.system(size: 45, weight: .bold, design: .rounded)
        public static let displaySmall = Font.system(size: 36, weight: .bold, design: .rounded)

        // MARK: - Headline
        public static let headlineLarge = Font.system(size: 32, weight: .semibold, design: .rounded)
        public static let headlineMedium = Font.system(size: 28, weight: .semibold, design: .rounded)
        public static let headlineSmall = Font.system(size: 24, weight: .semibold, design: .rounded)

        // MARK: - Title
        public static let titleLarge = Font.system(size: 22, weight: .semibold, design: .rounded)
        public static let titleMedium = Font.system(size: 18, weight: .medium, design: .rounded)
        public static let titleSmall = Font.system(size: 16, weight: .medium, design: .rounded)

        // MARK: - Body
        public static let bodyLarge = Font.system(size: 17, weight: .regular, design: .rounded)
        public static let bodyMedium = Font.system(size: 15, weight: .regular, design: .rounded)
        public static let bodySmall = Font.system(size: 13, weight: .regular, design: .rounded)

        // MARK: - Label
        public static let labelLarge = Font.system(size: 15, weight: .medium, design: .rounded)
        public static let labelMedium = Font.system(size: 13, weight: .medium, design: .rounded)
        public static let labelSmall = Font.system(size: 11, weight: .medium, design: .rounded)

        // MARK: - Caption
        public static let caption = Font.system(size: 12, weight: .regular, design: .rounded)
        public static let captionSmall = Font.system(size: 10, weight: .regular, design: .rounded)
    }
}

// MARK: - Typography Style
public enum SHTypographyStyle {
    case displayLarge
    case displayMedium
    case displaySmall
    case headlineLarge
    case headlineMedium
    case headlineSmall
    case titleLarge
    case titleMedium
    case titleSmall
    case bodyLarge
    case bodyMedium
    case bodySmall
    case labelLarge
    case labelMedium
    case labelSmall
    case caption
    case captionSmall

    public var font: Font {
        switch self {
        case .displayLarge: return SH.typography.displayLarge
        case .displayMedium: return SH.typography.displayMedium
        case .displaySmall: return SH.typography.displaySmall
        case .headlineLarge: return SH.typography.headlineLarge
        case .headlineMedium: return SH.typography.headlineMedium
        case .headlineSmall: return SH.typography.headlineSmall
        case .titleLarge: return SH.typography.titleLarge
        case .titleMedium: return SH.typography.titleMedium
        case .titleSmall: return SH.typography.titleSmall
        case .bodyLarge: return SH.typography.bodyLarge
        case .bodyMedium: return SH.typography.bodyMedium
        case .bodySmall: return SH.typography.bodySmall
        case .labelLarge: return SH.typography.labelLarge
        case .labelMedium: return SH.typography.labelMedium
        case .labelSmall: return SH.typography.labelSmall
        case .caption: return SH.typography.caption
        case .captionSmall: return SH.typography.captionSmall
        }
    }
}

// MARK: - View Extension
public extension View {
    func shFont(_ style: SHTypographyStyle) -> some View {
        self.font(style.font)
    }
}
