import SwiftUI

// MARK: - SHIcon

public struct SHIcon: View {
    @Environment(\.shTheme) private var theme

    private let name: String
    private let size: SHIconSize
    private let weight: Font.Weight
    private let color: Color?

    public init(
        _ name: String,
        size: SHIconSize = .md,
        weight: Font.Weight = .regular,
        color: Color? = nil
    ) {
        self.name = name
        self.size = size
        self.weight = weight
        self.color = color
    }

    public var body: some View {
        Image(systemName: name)
            .font(.system(size: size.value, weight: weight))
            .foregroundStyle(color ?? theme.colors.textPrimary)
            // 아이콘은 기본적으로 장식이다. 의미가 있으면 호출부에서
            // accessibilityLabel을 붙여 되살린다.
            .accessibilityHidden(true)
    }
}

// MARK: - SHCircledIcon

/// 원형 배경을 두른 아이콘. 리스트 리딩, 액션 카드 등에 쓴다.
public struct SHCircledIcon: View {
    @Environment(\.shTheme) private var theme

    private let name: String
    private let size: SHIconSize
    private let role: Role

    public enum Role: Sendable, CaseIterable {
        case brand      // 브랜드 채움색
        case tinted     // 파스텔 컨테이너 — 시그니처 룩
        case outlined
        case glass
        case neutral
    }

    public init(_ name: String, size: SHIconSize = .md, role: Role = .tinted) {
        self.name = name
        self.size = size
        self.role = role
    }

    private var containerSize: CGFloat { size.value * 2 }

    public var body: some View {
        ZStack {
            background
            Image(systemName: name)
                .font(.system(size: size.value, weight: .semibold))
                .foregroundStyle(foreground)
        }
        .frame(width: containerSize, height: containerSize)
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var background: some View {
        switch role {
        case .brand:
            Circle().fill(theme.colors.primary)
        case .tinted:
            Circle().fill(theme.colors.primaryContainer)
        case .outlined:
            Circle().stroke(theme.colors.primaryText, lineWidth: SH.size.borderEmphasis)
        case .glass:
            Circle().fill(.ultraThinMaterial)
                .overlay(Circle().stroke(theme.colors.glassBorder, lineWidth: SH.size.border))
        case .neutral:
            Circle().fill(theme.colors.surfaceSunken)
        }
    }

    private var foreground: Color {
        switch role {
        case .brand:    return theme.colors.onPrimary
        case .tinted:   return theme.colors.onPrimaryContainer
        case .outlined: return theme.colors.primaryText
        case .glass:    return theme.colors.textPrimary
        case .neutral:  return theme.colors.textSecondary
        }
    }
}

// MARK: - Preview

#Preview("Circled Icon Roles") {
    HStack(spacing: SH.spacing.md) {
        ForEach(Array(SHCircledIcon.Role.allCases.enumerated()), id: \.offset) { _, role in
            SHCircledIcon("star.fill", size: .lg, role: role)
        }
    }
    .padding()
    .background(SHThemeBackground())
    .shTheme(.peach)
}
