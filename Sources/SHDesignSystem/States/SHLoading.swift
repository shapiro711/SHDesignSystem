import SwiftUI

// MARK: - SHLoadingView

/// 화면 전체 로딩. 비동기 화면의 기본 상태다.
public struct SHLoadingView: View {
    @Environment(\.shTheme) private var theme

    private let message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: SH.spacing.md) {
            SHSpinner(size: .lg)
            if let message {
                SHText(message, \.bodyMedium, role: .secondary, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(message ?? "불러오는 중"))
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - SHSpinner

public struct SHSpinner: View {
    @Environment(\.shTheme) private var theme
    @State private var isSpinning = false

    private let size: SHIconSize
    private let color: Color?

    public init(size: SHIconSize = .md, color: Color? = nil) {
        self.size = size
        self.color = color
    }

    private var diameter: CGFloat { size.value * 1.4 }

    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.72)
            .stroke(
                color ?? theme.colors.primaryText,
                style: StrokeStyle(lineWidth: max(diameter * 0.12, 2), lineCap: .round)
            )
            .frame(width: diameter, height: diameter)
            .rotationEffect(.degrees(isSpinning ? 360 : 0))
            .animation(.linear(duration: 0.9).repeatForever(autoreverses: false), value: isSpinning)
            .onAppear { isSpinning = true }
            .accessibilityHidden(true)
    }
}

// MARK: - Loading Overlay

struct SHLoadingOverlayModifier: ViewModifier {
    @Environment(\.shTheme) private var theme

    let isLoading: Bool
    let message: String?

    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    ZStack {
                        theme.colors.scrim.ignoresSafeArea()

                        VStack(spacing: SH.spacing.sm) {
                            SHSpinner(size: .lg)
                            if let message {
                                SHText(message, \.labelMedium, role: .secondary)
                            }
                        }
                        .padding(SH.spacing.xl)
                        .shSurface(.elevated, shape: theme.shape.card)
                    }
                    .transition(.opacity)
                    // 로딩 중에는 뒤쪽 요소가 VoiceOver에 노출되면 안 된다.
                    .accessibilityAddTraits(.isModal)
                }
            }
            .animation(theme.motion.standard, value: isLoading)
    }
}

public extension View {
    /// 화면 위에 로딩을 덮는다. 진행 중 조작을 막는다.
    func shLoadingOverlay(_ isLoading: Bool, message: String? = nil) -> some View {
        modifier(SHLoadingOverlayModifier(isLoading: isLoading, message: message))
    }
}

// MARK: - SHProgressBar

public struct SHProgressBar: View {
    @Environment(\.shTheme) private var theme

    private let value: Double
    private let total: Double
    private let label: String?
    private let showsValue: Bool

    public init(value: Double, total: Double = 1, label: String? = nil, showsValue: Bool = false) {
        self.value = value
        self.total = total
        self.label = label
        self.showsValue = showsValue
    }

    private var fraction: Double {
        guard total > 0 else { return 0 }
        return min(max(value / total, 0), 1)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SH.spacing.xxs) {
            if label != nil || showsValue {
                HStack {
                    if let label {
                        SHText(label, \.labelMedium, role: .secondary)
                    }
                    Spacer()
                    if showsValue {
                        SHText("\(Int(fraction * 100))%", \.labelMedium, role: .secondary)
                    }
                }
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(theme.colors.surfaceSunken)
                    Capsule()
                        .fill(theme.colors.primary)
                        .frame(width: proxy.size.width * fraction)
                }
            }
            .frame(height: SH.spacing.xs)
            .animation(theme.motion.standard, value: fraction)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(label ?? "진행률"))
        .accessibilityValue(Text("\(Int(fraction * 100))퍼센트"))
    }
}

// MARK: - Preview

#Preview("Loading") {
    VStack(spacing: SH.spacing.xl) {
        HStack(spacing: SH.spacing.lg) {
            SHSpinner(size: .sm)
            SHSpinner(size: .md)
            SHSpinner(size: .lg)
        }
        SHProgressBar(value: 0.35, label: "업로드 중", showsValue: true)
        SHProgressBar(value: 0.8)
    }
    .padding()
    .frame(maxHeight: .infinity)
    .background(SHThemeBackground())
    .shTheme(.sky)
}
