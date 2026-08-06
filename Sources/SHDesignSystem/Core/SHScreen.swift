import SwiftUI

// MARK: - Theme Background

/// 테마 배경색을 화면 전체에 깐다.
public struct SHThemeBackground: View {
    @Environment(\.shTheme) private var theme

    public init() {}

    public var body: some View {
        theme.colors.background.ignoresSafeArea()
    }
}

// MARK: - Screen

/// 화면 루트 컨테이너. 배경과 안전영역 처리를 한 곳으로 모은다.
public struct SHScreen<Content: View>: View {
    @Environment(\.shTheme) private var theme

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ZStack {
            SHThemeBackground()
            content
        }
    }
}
