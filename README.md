# SHDesignSystem

파스텔 톤 시그니처를 가진 iOS SwiftUI 디자인 시스템.

여러 앱을 빠르게 찍어내기 위해 만들었습니다. **시그니처(둥근 서체, 넉넉한 라운딩, 파스텔 컨테이너, 탄력 있는 모션)는 코드에 고정되어 있고, 앱마다 바꾸는 값은 색조(hue) 하나뿐입니다.**

```swift
ContentView().shTheme(SHTheme(hue: 312))
```

이 한 줄에서 채움색·컨테이너·글자색·중립색·상태색·그림자까지 전부 생성됩니다.

---

## 요구사항

- iOS 18.0+
- Swift 6.0+ / Xcode 16+

## 설치

```swift
dependencies: [
    .package(url: "https://github.com/shapiro711/SHDesignSystem.git", from: "2.0.0")
]

.target(
    name: "YourApp",
    dependencies: ["SHDesignSystemKit"]
)
```

```swift
import SHDesignSystemKit
```

---

## 빠른 시작

```swift
import SwiftUI
import SHDesignSystemKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .shTheme(.lavender)   // 앱 루트에서 한 번만
        }
    }
}

struct RootView: View {
    @State private var email = ""
    @State private var toast: SHToast?

    var body: some View {
        SHScreen {
            VStack(spacing: SH.spacing.lg) {
                SHText("환영합니다", \.headlineMedium)

                SHInputField("이메일", text: $email,
                             helperText: "로그인에 사용할 주소예요",
                             icon: "envelope",
                             keyboardType: .emailAddress)

                SHButton("시작하기", variant: .primary, fillsWidth: true) {
                    toast = .success("가입했어요")
                }
            }
            .padding(SH.spacing.md)
        }
        .shToast($toast)
    }
}
```

---

## 핵심 개념

### 1. 테마는 hue 하나

```swift
// 프리셋
.shTheme(.lavender)   // 268°
.shTheme(.pink)       // 340°
.shTheme(.mint)       // 166°
.shTheme(.peach)      //  22°
.shTheme(.sky)        // 205°
.shTheme(.lemon)      //  48°

// 새 앱 색조
.shTheme(SHTheme(hue: 312))
.shTheme(hue: 312)             // 축약형
```

컴포넌트는 색을 직접 고르지 않고 `@Environment(\.shTheme)`에서 받습니다. 그래서 루트에서 테마를 바꾸면 화면 전체가 따라옵니다.

### 2. 색은 역할로 참조한다

원시 색상 팔레트(`SH.colors.pink` 같은 것)는 없습니다. **역할만 있습니다.**

| 역할 | 쓰는 곳 |
|---|---|
| `primary` / `onPrimary` | 채움 버튼, 강조 배경 |
| `primaryContainer` / `onPrimaryContainer` | 파스텔 틴트 — 시그니처 룩 |
| `primaryText` | **표면 위 브랜드 글자** — 고스트 버튼, 링크 |
| `surface` / `surfaceElevated` / `surfaceSunken` | 카드, 입력 배경 |
| `textPrimary` / `textSecondary` / `textTertiary` | 본문 계층 |
| `success` / `warning` / `error` / `info` (+ `on…`, `…Container`) | 상태 |

**`primary`를 글자색으로 쓰면 안 됩니다.** 채움색은 배경으로 쓸 때 대비를 맞춘 값이라 밝은 색조에서 표면 위 글자로는 깨집니다. 표면 위 브랜드 글자는 `primaryText`입니다.

### 3. 대비는 계산으로 보장된다

색을 손으로 찍지 않고, 전경색과의 대비가 **WCAG AA(4.5:1)** 이상이 될 때까지 밝기를 조정해서 뽑습니다. 그래서 어떤 hue를 넣어도 무너지지 않습니다.

전경색은 밝은 잉크/어두운 잉크 중 유리한 쪽을 자동으로 고릅니다. 노랑 계열은 "밝은 배경 + 어두운 글씨", 보라 계열은 "진한 배경 + 흰 글씨"로 갈립니다.

### 4. 타이포는 Dynamic Type을 따른다

17개 토큰 전부 `@ScaledMetric`으로 스케일되어 사용자 글자 크기 설정에 반응합니다. 본문은 한글 가독성을 위해 1.5배 행간이 들어갑니다.

```swift
SHText("제목", \.titleLarge)
Text("직접 쓸 때").shFont(\.bodyMedium)
```

### 5. 모양은 컴포넌트 역할로

```swift
theme.shape.button      // .rounded(18)
theme.shape.control     // .rounded(16)  TextField, SearchBar
theme.shape.card        // .rounded(24)
theme.shape.sheet       // .rounded(32)
theme.shape.chip        // .capsule
```

반경 값을 직접 고르지 말고 역할을 쓰면, 나중에 시그니처를 각지게 바꿔도 한 곳만 고치면 됩니다.

---

## 토큰

앱마다 달라지지 않는 레이아웃 상수는 `SH` 네임스페이스에 있습니다.

```swift
SH.spacing.xxxs  // 2
SH.spacing.xxs   // 4
SH.spacing.xs    // 8
SH.spacing.sm    // 12
SH.spacing.md    // 16   기본
SH.spacing.lg    // 20
SH.spacing.xl    // 24
SH.spacing.xxl   // 32
SH.spacing.xxxl  // 40
SH.spacing.section // 48
SH.spacing.page  // 64

SH.size.controlSmall / controlMedium / controlLarge   // 36 / 48 / 56
SH.size.iconXS … iconXXL                              // 12 … 48
SH.size.border / borderEmphasis                       // 1 / 2
SH.size.minTapTarget                                  // 44
```

테마에 속한 토큰(색·타이포·모양·깊이·모션)은 환경에서 받습니다.

```swift
@Environment(\.shTheme) private var theme

theme.colors.primary
theme.typography.titleMedium
theme.shape.card
theme.elevation.floating
theme.motion.standard
```

---

## 컴포넌트

### Atoms
`SHButton` `SHIconButton` `SHText` `SHIconText` `SHIcon` `SHCircledIcon`
`SHDivider` `SHLabeledDivider` `SHTextField` `SHTextArea`
`SHAvatar` `SHAvatarGroup` `SHBadge` `SHTag`

### Controls
`SHToggle` `SHCheckbox` `SHRadioGroup` `SHSegmentedControl` `SHStepper` `SHSlider`

### Molecules
`SHInputField` `SHSearchBar` `SHChip` `SHChipGroup`
`SHListItem` `SHNavigationRow` `SHToggleRow`

### Organisms
`SHCard` `SHImageCard` `SHActionCard` `SHStatCard`
`SHHeader` `SHNavigationHeader` `SHSectionHeader`
`SHBottomSheet`(modifier) `SHActionSheet`

### Feedback
`SHToast` `SHDialog`

### States
`SHLoadingView` `SHSpinner` `SHProgressBar`
`SHSkeleton` `SHSkeletonRow` `SHSkeletonParagraph`
`SHEmptyState` `SHErrorState` `SHStateView`

### Navigation
`SHTabBar` `SHBottomBar`

### Layout
`SHScreen` `SHThemeBackground` `SHFlowLayout`

---

## 비동기 화면

로딩·성공·빈 상태·에러 분기를 화면마다 반복하지 않도록 `SHStateView`를 씁니다.

```swift
@State private var state: SHLoadState<[Item]> = .loading

SHStateView(
    state,
    emptyState: SHEmptyState(
        icon: "note.text",
        title: "아직 기록이 없어요",
        message: "첫 기록을 남겨보세요.",
        actionTitle: "기록 추가"
    ) { addItem() },
    onRetry: { reload() }
) { items in
    ForEach(items) { item in
        SHNavigationRow(item.title, icon: item.icon) { open(item) }
    }
}
```

---

## 접근성

시스템이 기본으로 보장하는 것들입니다.

- **대비** — 모든 색 조합이 WCAG AA(4.5:1) 이상
- **Dynamic Type** — 전체 타이포 토큰이 스케일됨
- **VoiceOver** — `SHIconButton`은 `accessibilityLabel`이 **필수 인자**. 장식 아이콘은 자동으로 감춰짐
- **터치 영역** — `.shMinTapTarget()`으로 44pt 보장
- **모션 감소** — 스켈레톤 셔머가 `reduceMotion`을 따름
- **상태 전달** — `.disabled()`를 쓰므로 VoiceOver에 비활성 상태가 전달됨

---

## 카탈로그 앱

저장소를 열고 `SHDesignSystem` 스킴을 실행하면 전체 카탈로그를 볼 수 있습니다.
최상단 **색조 슬라이더**를 드래그하면 시스템 전체가 실시간으로 다시 칠해집니다 — 새 앱 색조를 눈으로 고르는 화면입니다.

```bash
xcodebuild -scheme SHDesignSystem \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build
```

---

## 라이선스

개인 프로젝트용.
