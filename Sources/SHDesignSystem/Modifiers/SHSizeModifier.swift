import SwiftUI

// MARK: - Size Modifier
public struct SHSizeModifier: ViewModifier {
    public enum Size {
        case small
        case medium
        case large
        case custom(width: CGFloat?, height: CGFloat?)
    }

    private let size: Size

    public init(size: Size) {
        self.size = size
    }

    public func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
    }

    private var width: CGFloat? {
        switch size {
        case .small: return 120
        case .medium: return 200
        case .large: return 280
        case .custom(let w, _): return w
        }
    }

    private var height: CGFloat? {
        switch size {
        case .small: return 36
        case .medium: return 48
        case .large: return 56
        case .custom(_, let h): return h
        }
    }
}

// MARK: - Full Width Modifier
public struct SHFullWidthModifier: ViewModifier {
    private let alignment: Alignment

    public init(alignment: Alignment = .center) {
        self.alignment = alignment
    }

    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

// MARK: - View Extensions
public extension View {
    func shSize(_ size: SHSizeModifier.Size) -> some View {
        self.modifier(SHSizeModifier(size: size))
    }

    func shFullWidth(alignment: Alignment = .center) -> some View {
        self.modifier(SHFullWidthModifier(alignment: alignment))
    }

    func shSquare(_ size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }
}
