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
///
/// 배경이 안전영역을 넘어 바 아래까지 깔린다. 리퀴드 글래스 바는 자기 뒤를
/// 지나가는 픽셀을 굴절시켜 그리므로, 콘텐츠가 바 밑으로 들어가야 한다.
/// `SHScreen` 안에는 `ScrollView`나 `List`를 그대로 넣고, 바를 피하려고
/// 상·하단에 여백을 직접 주지 않는다 — 안전영역은 시스템이 넣어 준다.
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
