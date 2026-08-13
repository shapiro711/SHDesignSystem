# SHDesignSystem

파스텔 톤 시그니처를 가진 iOS SwiftUI 디자인 시스템.

여러 앱을 빠르게 찍어내기 위해 만들었습니다. **시그니처(둥근 서체, 넉넉한 라운딩, 파스텔 컨테이너, 탄력 있는 모션)는 코드에 고정되어 있고, 앱마다 바꾸는 값은 색조(hue) 하나뿐입니다.**

```swift
ContentView().shTheme(SHTheme(hue: 312))
```

이 한 줄에서 채움색·컨테이너·글자색·중립색·상태색·그림자까지 전부 생성됩니다.

---

## 요구사항

- iOS 26.0+
- Swift 6.2+ / Xcode 26+

버전 분기는 두지 않습니다. 리퀴드 글래스가 항상 있다고 가정하고 씁니다.

## 설치

```swift
dependencies: [
    .package(url: "https://github.com/shapiro711/SHDesignSystem.git", from: "3.0.0")
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

### 3. 채움색 대비는 계산으로 뽑는다

`primary`·`secondary`·상태 채움색과 `primaryText`는 색을 손으로 찍지 않고, 전경색과의 대비가 **WCAG AA(4.5:1)** 이상이 될 때까지 밝기를 조정해서 뽑습니다. 그래서 어떤 hue를 넣어도 버튼 글자나 링크가 묻히지 않습니다.

전경색은 밝은 잉크/어두운 잉크 중 유리한 쪽을 자동으로 고릅니다. 노랑 계열은 "밝은 배경 + 어두운 글씨", 보라 계열은 "진한 배경 + 흰 글씨"로 갈립니다.

컨테이너 계열과 중립색(표면·글자·선)은 계산을 거치지 않는 **시그니처 팔레트의 고정값**입니다. 실측 대비는 프리셋 포함 hue 11종 기준으로 컨테이너 조합 7.9:1 이상, `textPrimary` 13.8:1 이상, `textSecondary` 5.6:1 이상입니다. **`textTertiary`만 3.0~4.4로 AA 본문 기준에 못 미치므로** chevron·부가 정보 전용으로 쓰고, 읽어야 하는 글자에는 `textSecondary`를 씁니다.

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

### 6. 네비게이션 바와 탭바는 애플 것을 쓴다

시그니처가 적용되지 **않는** 유일한 자리입니다. 바는 시스템이 리퀴드 글래스로 그리고, 이 디자인 시스템이 얹는 건 테마 tint뿐입니다.

```swift
SHTabView(tabItems, selection: $selection) { tab in
    NavigationStack {
        SHScreen { ScrollView { … } }
            .shNavigationBar("기록", trailingIcon: "plus", trailingLabel: "추가") { add() }
    }
}
```

리퀴드 글래스는 바 뒤로 지나가는 콘텐츠의 굴절·명암·스크롤 가장자리 반응을 시스템이 매 프레임 계산하는 것이라, `Material` 한 겹으로는 재현되지 않고 흉내 내면 OS가 바뀔 때마다 우리 것만 어긋납니다. 그래서 2.x의 커스텀 탭바(선택 탭 파스텔 pill)를 포기했습니다. 나머지 자리 — 카드, 칩, 버튼, 시트 — 의 시그니처는 그대로입니다.

`SHScreen` 안에는 `ScrollView`나 `List`를 그대로 넣고, 바를 피하려고 여백을 직접 주지 마세요. 콘텐츠가 바 **밑으로** 지나가야 유리가 살아납니다.

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
`SHAvatar` `SHAvatarGroup` `SHBadge` `SHTag` `SHTokenBadge`

### Controls
`SHToggle` `SHCheckbox` `SHRadioGroup` `SHSegmentedControl` `SHStepper` `SHSlider`
`SHDatePicker` `SHThemePicker`

### Molecules
`SHInputField` `SHSearchBar` `SHChip` `SHChipGroup`
`SHListItem` `SHNavigationRow` `SHToggleRow`

### Organisms
`SHCard` `SHImageCard` `SHActionCard` `SHStatCard`
`SHHeader` `SHSectionHeader`
`SHBottomSheet`(modifier) `SHActionSheet`

### Feedback
`SHToast` `SHDialog`

### States
`SHLoadingView` `SHSpinner` `SHProgressBar`
`SHSkeleton` `SHSkeletonRow` `SHSkeletonParagraph`
`SHEmptyState` `SHErrorState` `SHStateView`

### Navigation
`SHTabView` `shNavigationBar`(modifier) `SHToolbarButton` `SHBottomBar` `SHPageIndicator`

### Charts
`SHBarChart`

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

- **대비** — 채움색(`primary`·`secondary`·상태색)과 `primaryText`는 AA(4.5:1)까지 계산으로 끌어올림. 컨테이너·중립색은 고정값이며 `textTertiary`(3.0~4.4)만 AA 본문 기준 미달 — 부가 정보 전용
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

## 3.1.0 — 앱이 소유한 색을 위한 배지

`SHBadge`·`SHTag`는 색을 테마 상태(`SHStatusKind`)에서 꺼내 씁니다. 그래서 **앱이 데이터로 소유한 색**은 그리지 못했습니다 — 사용자가 고른 근무 유형 색, 카테고리 색, 캘린더 색처럼 테마 색조를 바꿔도 따라 변하면 안 되는 값들입니다.

그 자리를 앱마다 인라인으로 다시 만들다 보면(`Text` + `.font(.system(size:))` + `.background` + `.clipShape`) 크기·모양·Dynamic Type 대응이 호출부마다 갈립니다. `SHTokenBadge`가 그 조각을 흡수합니다.

```swift
SHTokenBadge(
    "N",
    foreground: myPalette.ink,        // 색만 밖에서 받는다
    container: myPalette.container,
    size: .md,                        // .sm / .md / .lg / .xl
    layout: .tile,                    // .pill / .tile / .wide
    isMuted: type.isOffDuty           // 후퇴시킬 때
)
```

- 타이포는 `labelMedium`~`headlineSmall` 토큰에서 굵기만 bold로 바꿔 씁니다 — **Dynamic Type을 그대로 따릅니다.**
- 색면 크기도 `@ScaledMetric`으로 함께 커집니다. 글자만 커지고 색면이 고정이면 라벨이 잘립니다.
- 모양은 `theme.shape.badge`(pill) / `theme.shape.thumbnail`(tile·wide)를 따릅니다.
- **두 색의 대비는 넘기는 쪽 책임입니다.** `SHColorMath.contrastRatio(_:_:)`로 검증하세요 — 테마가 만든 색이 아니라 계산 보정을 태울 수 없습니다.

추가만 있고 기존 API 변경은 없습니다.

---

## 3.0.0 마이그레이션

네비게이션 바와 탭바를 시스템에 넘기고, **배포 타깃을 iOS 26으로 올렸습니다.** 버전 분기를 코드에 두지 않기 위한 선택입니다 — 대신 iOS 18~25 기기는 지원하지 않습니다.

| 2.x | 3.0 |
|---|---|
| `SHTabBar(items, selection:)` — 바만 그림 | `SHTabView(items, selection:) { tab in … }` — 콘텐츠까지 감쌈 |
| `SHNavigationHeader("제목", trailingIcon:…)` | `.shNavigationBar("제목", trailingIcon:…)` |
| `SHHeaderStyle.glass` | 삭제 (시스템 바가 담당) |
| `SHTabItem(badge: SHBadge?)` | `SHTabItem(badge: SHTabBadge?)` — `.count` / `.text`, 점 배지 없음 |
| 툴바 안 `SHIconButton` | `SHToolbarButton` |
| `shGlass(_:shape:showsBorder:)` / `SHGlassStyle` | 삭제 (호출부가 없던 API). 바 배경은 `shBarGlass()` |
| tint = `primary` | tint = `primaryText` |
| iOS 18.0+ / swift-tools 6.0 | iOS 26.0+ / swift-tools 6.2 |

화면 구조도 함께 바뀝니다. 바를 `VStack`으로 쌓던 것을 `NavigationStack` + `SHTabView`로 옮기고, 탭마다 스택을 따로 둡니다.

```swift
// 2.x
VStack(spacing: 0) { header; content; SHTabBar(items, selection: $tab) }

// 3.0
SHTabView(items, selection: $tab) { tab in
    NavigationStack {
        content(tab).shNavigationBar(title(tab))
    }
}
```

뒤로 가기 버튼과 스와이프 back은 `NavigationStack`이 줍니다 — `navigationBarBackButtonHidden(true)`와 직접 만든 chevron 버튼은 지우세요.

---

## 라이선스

개인 프로젝트용.
