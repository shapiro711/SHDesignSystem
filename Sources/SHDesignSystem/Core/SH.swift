import SwiftUI

// MARK: - SH Namespace
/// 앱마다 달라지지 않는 전역 스케일(간격·크기·반경)의 진입점.
///
/// 색·타이포·모양·깊이·모션처럼 **테마에 따라 달라지는 값은 여기 없다.**
/// 그런 값은 `@Environment(\.shTheme)`로 받아 쓴다. 이 구분이
/// 테마 교체가 실제로 동작하게 만드는 핵심이다.
public enum SH {
    // spacing / size / radius 는 Tokens 에서 extension 으로 정의된다.
}
