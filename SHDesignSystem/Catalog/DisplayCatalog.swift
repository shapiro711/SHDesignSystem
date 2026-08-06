import SwiftUI
import SHDesignSystemKit

// MARK: - Cards & Lists

struct DisplayCatalog: View {
    @Environment(\.shTheme) private var theme
    @State private var toggle = true

    var body: some View {
        CatalogPage {
            CatalogGroup("Card Surfaces") {
                VStack(spacing: SH.spacing.sm) {
                    SHCard(surface: .elevated) { cardBody("Elevated", "표면색 + 옅은 그림자") }
                    SHCard(surface: .outlined) { cardBody("Outlined", "표면색 + 테두리") }
                    SHCard(surface: .tinted) { cardBody("Tinted", "브랜드 파스텔 컨테이너") }
                    SHCard(surface: .glass) { cardBody("Glass", "반투명 유리") }
                    SHCard(surface: .status(.warning)) { cardBody("Status", "상태색 컨테이너") }
                }
            }

            CatalogGroup("Action Card") {
                VStack(spacing: SH.spacing.sm) {
                    SHActionCard(title: "프로필 설정", subtitle: "이름과 사진을 변경해보세요", icon: "person.fill") {}
                    SHActionCard(title: "알림 설정", icon: "bell.fill", surface: .tinted) {}
                }
            }

            CatalogGroup("Stat Card") {
                HStack(spacing: SH.spacing.sm) {
                    SHStatCard(title: "총 수익", value: "₩1,234,567",
                               trend: .up("12.5%"), icon: "wonsign.circle.fill")
                    SHStatCard(title: "방문자", value: "8,234",
                               trend: .down("3.2%"), icon: "person.2.fill")
                }
            }

            CatalogGroup("List Rows") {
                VStack(spacing: SH.spacing.xxs) {
                    SHNavigationRow("프로필 설정", subtitle: "이름, 사진 변경", icon: "person.fill") {}
                    SHDivider(inset: SH.spacing.md)
                    SHNavigationRow("알림", icon: "bell.fill", value: "켜짐") {}
                    SHDivider(inset: SH.spacing.md)
                    SHToggleRow("다크 모드", icon: "moon.fill", isOn: $toggle)
                }
                .background(theme.colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: SH.radius.xl, style: .continuous))
            }

            CatalogGroup("Card Rows") {
                VStack(spacing: SH.spacing.xs) {
                    SHNavigationRow("카드형", icon: "square.stack.fill", surface: .elevated) {}
                    SHNavigationRow("틴트형", icon: "sparkles", surface: .tinted) {}
                    SHNavigationRow("아웃라인", icon: "square.dashed", surface: .outlined) {}
                }
            }
        }
    }

    private func cardBody(_ title: String, _ subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: SH.spacing.xxs) {
            SHText(title, \.titleMedium)
            SHText(subtitle, \.bodySmall, role: .secondary)
        }
    }
}

// MARK: - Chips, Badges, Avatars

struct AccentCatalog: View {
    @Environment(\.shTheme) private var theme
    @State private var selected: Set<String> = ["진행중"]

    var body: some View {
        CatalogPage {
            CatalogGroup("Chips") {
                VStack(alignment: .leading, spacing: SH.spacing.sm) {
                    ForEach(SHChipVariant.allCases, id: \.self) { variant in
                        HStack(spacing: SH.spacing.xs) {
                            SHChip(variant.displayName, icon: "tag.fill", variant: variant)
                            SHChip("선택됨", variant: variant, isSelected: true, action: {})
                            SHChip("삭제", variant: variant, onRemove: {})
                        }
                    }
                }
            }

            CatalogGroup("Chip Group") {
                SHChipGroup(["전체", "진행중", "완료", "보관됨", "즐겨찾기"], selection: $selected)
            }

            CatalogGroup("Tags") {
                HStack(spacing: SH.spacing.xs) {
                    SHTag("완료", kind: .success, icon: "checkmark")
                    SHTag("진행중", kind: .info)
                    SHTag("지연", kind: .warning)
                    SHTag("실패", kind: .error)
                }
            }

            CatalogGroup("Badges") {
                HStack(spacing: SH.spacing.xl) {
                    SHIcon("bell.fill", size: .xl).shBadge(.count(3))
                    SHIcon("envelope.fill", size: .xl).shBadge(.count(128))
                    SHIcon("person.fill", size: .xl).shBadge(SHBadge(.dot))
                    SHIcon("bag.fill", size: .xl).shBadge(SHBadge(.text("NEW"), kind: .info))
                }
            }

            CatalogGroup("Avatars") {
                VStack(alignment: .leading, spacing: SH.spacing.md) {
                    HStack(spacing: SH.spacing.md) {
                        SHAvatar(.initials("김도형"), size: 56, accessibilityLabel: "김도형")
                        SHAvatar(.initials("Ada Lovelace"), size: 56)
                        SHAvatar(.icon("person.fill"), size: 56)
                        SHAvatar(.icon("pawprint.fill"), size: 56)
                    }
                    SHAvatarGroup([
                        .initials("김"), .initials("이"), .initials("박"),
                        .initials("최"), .initials("정"), .initials("한")
                    ])
                }
            }

            CatalogGroup("Circled Icons") {
                HStack(spacing: SH.spacing.md) {
                    SHCircledIcon("star.fill", size: .lg, role: .brand)
                    SHCircledIcon("star.fill", size: .lg, role: .tinted)
                    SHCircledIcon("star.fill", size: .lg, role: .outlined)
                    SHCircledIcon("star.fill", size: .lg, role: .glass)
                    SHCircledIcon("star.fill", size: .lg, role: .neutral)
                }
            }
        }
    }
}
