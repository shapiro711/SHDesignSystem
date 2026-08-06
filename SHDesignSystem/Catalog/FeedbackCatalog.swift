import SwiftUI
import SHDesignSystemKit

// MARK: - Feedback

struct FeedbackCatalog: View {
    @Environment(\.shTheme) private var theme

    @State private var toast: SHToast?
    @State private var showsDialog = false
    @State private var showsDestructiveDialog = false
    @State private var showsSheet = false
    @State private var showsActionSheet = false

    var body: some View {
        CatalogPage {
            CatalogGroup("Toast") {
                VStack(spacing: SH.spacing.sm) {
                    SHButton("성공 토스트", variant: .secondary, fillsWidth: true) {
                        toast = .success("저장했어요")
                    }
                    SHButton("에러 토스트", variant: .secondary, fillsWidth: true) {
                        toast = .error("저장에 실패했어요")
                    }
                    SHButton("정보 토스트", variant: .secondary, fillsWidth: true) {
                        toast = .info("동기화 중이에요")
                    }
                    SHButton("경고 토스트", variant: .secondary, fillsWidth: true) {
                        toast = SHToast("저장 공간이 부족해요", kind: .warning)
                    }
                }
            }

            CatalogGroup("Dialog") {
                VStack(spacing: SH.spacing.sm) {
                    SHButton("확인 다이얼로그", variant: .secondary, fillsWidth: true) {
                        showsDialog = true
                    }
                    SHButton("삭제 다이얼로그", variant: .destructive, fillsWidth: true) {
                        showsDestructiveDialog = true
                    }
                }
            }

            CatalogGroup("Bottom Sheet") {
                VStack(spacing: SH.spacing.sm) {
                    SHButton("시트 열기", variant: .secondary, fillsWidth: true) {
                        showsSheet = true
                    }
                    SHButton("액션 시트", variant: .secondary, fillsWidth: true) {
                        showsActionSheet = true
                    }
                }
            }

            CatalogGroup("Progress") {
                VStack(spacing: SH.spacing.md) {
                    SHProgressBar(value: 0.35, label: "업로드 중", showsValue: true)
                    SHProgressBar(value: 0.8)
                }
            }
        }
        .shToast($toast)
        .shDialog(isPresented: $showsDialog) {
            SHDialog(
                icon: "checkmark.seal.fill",
                title: "변경사항을 저장할까요?",
                message: "지금 저장하지 않으면 작성한 내용이 사라져요.",
                primary: .init("저장"),
                secondary: .init("취소", role: .cancel)
            )
        }
        .shDialog(isPresented: $showsDestructiveDialog) {
            SHDialog(
                icon: "trash.fill",
                title: "정말 삭제할까요?",
                message: "삭제한 기록은 되돌릴 수 없어요.",
                primary: .init("삭제", role: .destructive) { toast = .success("삭제했어요") },
                secondary: .init("취소", role: .cancel)
            )
        }
        .shBottomSheet(isPresented: $showsSheet, detent: .medium) {
            VStack(alignment: .leading, spacing: SH.spacing.md) {
                SHText("시트 콘텐츠", \.titleLarge)
                SHText("시트 안에서도 테마가 그대로 이어집니다.", \.bodyMedium, role: .secondary)
                SHCard(surface: .tinted) {
                    SHText("파스텔 컨테이너", \.bodyMedium,
                           role: .custom(theme.colors.onPrimaryContainer))
                }
                Spacer()
            }
            .padding(SH.spacing.lg)
        }
        .shBottomSheet(isPresented: $showsActionSheet, detent: .fitContent) {
            SHActionSheet(
                title: "파일 옵션",
                message: "이 파일로 무엇을 하시겠어요?",
                actions: [
                    .init("공유", icon: "square.and.arrow.up") { toast = .info("공유") },
                    .init("복사", icon: "doc.on.doc") { toast = .info("복사") },
                    .init("삭제", icon: "trash", role: .destructive) { toast = .error("삭제") }
                ]
            )
        }
    }
}

// MARK: - States

struct StateCatalog: View {
    @Environment(\.shTheme) private var theme

    @State private var state: SHLoadState<[String]> = .loaded(["첫 번째", "두 번째", "세 번째"])
    @State private var showsOverlay = false

    var body: some View {
        CatalogPage {
            CatalogGroup("Spinner") {
                HStack(spacing: SH.spacing.lg) {
                    SHSpinner(size: .sm)
                    SHSpinner(size: .md)
                    SHSpinner(size: .lg)
                    SHSpinner(size: .xl)
                }
            }

            CatalogGroup("Skeleton") {
                VStack(alignment: .leading, spacing: SH.spacing.sm) {
                    SHSkeletonRow()
                    SHSkeletonRow()
                    SHSkeletonParagraph()
                }
                .padding(.vertical, SH.spacing.xs)
                .background(theme.colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous))
            }

            CatalogGroup("SHStateView — 한 곳에서 상태를 분기합니다") {
                VStack(spacing: SH.spacing.sm) {
                    SHSegmentedControl(["로딩", "성공", "빈 상태", "에러"], selection: stateSelection)

                    SHStateView(
                        state,
                        emptyState: SHEmptyState(
                            icon: "note.text",
                            title: "아직 기록이 없어요",
                            message: "첫 기록을 남겨보세요.",
                            actionTitle: "기록 추가"
                        ) {},
                        onRetry: { state = .loading }
                    ) { items in
                        VStack(spacing: SH.spacing.xxs) {
                            ForEach(items, id: \.self) { item in
                                SHListItem(item, subtitle: "설명", surface: .elevated)
                            }
                        }
                    }
                    .frame(height: 280)
                    .background(theme.colors.surfaceSunken.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous))
                }
            }

            CatalogGroup("Loading Overlay") {
                SHButton("2초간 오버레이", variant: .secondary, fillsWidth: true) {
                    showsOverlay = true
                    Task {
                        try? await Task.sleep(for: .seconds(2))
                        showsOverlay = false
                    }
                }
            }
        }
        .shLoadingOverlay(showsOverlay, message: "저장 중이에요")
    }

    private var stateSelection: Binding<String> {
        Binding {
            switch state {
            case .idle, .loading: return "로딩"
            case .loaded(let items): return items.isEmpty ? "빈 상태" : "성공"
            case .failed: return "에러"
            }
        } set: { newValue in
            switch newValue {
            case "로딩": state = .loading
            case "성공": state = .loaded(["첫 번째", "두 번째", "세 번째"])
            case "빈 상태": state = .loaded([])
            default: state = .failed("네트워크 연결을 확인해주세요.")
            }
        }
    }
}

// MARK: - Navigation

struct NavigationCatalog: View {
    @Environment(\.shTheme) private var theme
    @State private var tab = 0

    var body: some View {
        VStack(spacing: 0) {
            CatalogPage {
                CatalogGroup("Headers") {
                    VStack(spacing: SH.spacing.md) {
                        SHHeader("헤더 타이틀", subtitle: "Standard") {
                            SHIconButton(icon: "ellipsis", accessibilityLabel: "더 보기") {}
                        }
                        SHDivider()
                        SHHeader("오늘의 기록", subtitle: "3개의 항목", style: .large)
                        SHDivider()
                        SHHeader("Glass", subtitle: "반투명 배경", style: .glass)
                    }
                    .background(theme.colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous))
                }

                CatalogGroup("Section Header") {
                    VStack {
                        SHSectionHeader("최근", actionTitle: "모두 보기") {}
                        SHSectionHeader("추천")
                    }
                }

                CatalogGroup("Bottom Bar") {
                    SHBottomBar {
                        HStack(spacing: SH.spacing.sm) {
                            SHButton("취소", variant: .ghost, fillsWidth: true) {}
                            SHButton("확인", variant: .primary, fillsWidth: true) {}
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: SH.radius.lg, style: .continuous))
                }
            }

            SHTabBar(
                [
                    SHTabItem(tag: 0, title: "홈", icon: "house", selectedIcon: "house.fill"),
                    SHTabItem(tag: 1, title: "탐색", icon: "magnifyingglass"),
                    SHTabItem(tag: 2, title: "알림", icon: "bell", selectedIcon: "bell.fill", badge: .count(5)),
                    SHTabItem(tag: 3, title: "내 정보", icon: "person", selectedIcon: "person.fill")
                ],
                selection: $tab
            )
        }
    }
}
