import SwiftUI

// MARK: - SHBottomBar

/// 화면 하단에 고정되는 액션 바. 시트나 폼의 확정 버튼에 쓴다.
///
/// **탭바가 있는 화면에서는 쓰지 않는다.** 유리 위에 유리를 겹치면 두 겹이 서로의
/// 배경을 굴절시켜 둘 다 탁해진다. 탭이 있는 화면에서 하단 액션이 필요하면
/// 시트로 올리거나 `.toolbar(placement: .bottomBar)`를 쓴다.
public struct SHBottomBar<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .padding(.horizontal, SH.spacing.md)
            .padding(.vertical, SH.spacing.sm)
            .frame(maxWidth: .infinity)
            .shBarGlass()
    }
}

// MARK: - Preview

#Preview("Bottom Bar") {
    VStack(spacing: 0) {
        SHScreen {
            SHText("콘텐츠", \.headlineMedium)
        }

        SHBottomBar {
            HStack(spacing: SH.spacing.sm) {
                SHButton("취소", variant: .ghost, fillsWidth: true) {}
                SHButton("확인", variant: .primary, fillsWidth: true) {}
            }
        }
    }
    .shTheme(.peach)
}
