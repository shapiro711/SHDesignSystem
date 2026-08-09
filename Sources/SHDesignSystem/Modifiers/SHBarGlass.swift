import SwiftUI

// MARK: - Bar Glass

public extension View {
    /// 화면 가장자리에 붙는 바(하단 액션 바 등)의 배경을 리퀴드 글래스로 만든다.
    ///
    /// 네비게이션 바와 탭바에는 **쓰지 않는다** — 그 둘은 시스템이 직접 그린다
    /// (`shNavigationBar`, `SHTabView`). 이 모디파이어는 시스템 바가 없는 자리에
    /// 바를 하나 더 놓아야 할 때만 쓴다.
    func shBarGlass() -> some View {
        glassEffect(.regular, in: .rect)
    }
}
