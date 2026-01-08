import XCTest
@testable import SHDesignSystem

final class SHDesignSystemTests: XCTestCase {
    func testSpacingValues() {
        XCTAssertEqual(SH.spacing.xxxs, 2)
        XCTAssertEqual(SH.spacing.xxs, 4)
        XCTAssertEqual(SH.spacing.xs, 8)
        XCTAssertEqual(SH.spacing.sm, 12)
        XCTAssertEqual(SH.spacing.md, 16)
        XCTAssertEqual(SH.spacing.lg, 20)
        XCTAssertEqual(SH.spacing.xl, 24)
        XCTAssertEqual(SH.spacing.xxl, 32)
        XCTAssertEqual(SH.spacing.xxxl, 40)
    }

    func testRadiusValues() {
        XCTAssertEqual(SH.radius.xs, 4)
        XCTAssertEqual(SH.radius.sm, 8)
        XCTAssertEqual(SH.radius.md, 12)
        XCTAssertEqual(SH.radius.lg, 16)
        XCTAssertEqual(SH.radius.xl, 20)
        XCTAssertEqual(SH.radius.xxl, 24)
        XCTAssertEqual(SH.radius.xxxl, 32)
    }

    func testThemeDisplayNames() {
        XCTAssertEqual(SHTheme.pastelPink.displayName, "파스텔 핑크")
        XCTAssertEqual(SHTheme.pastelMint.displayName, "파스텔 민트")
        XCTAssertEqual(SHTheme.pastelLavender.displayName, "파스텔 라벤더")
        XCTAssertEqual(SHTheme.pastelPeach.displayName, "파스텔 피치")
        XCTAssertEqual(SHTheme.pastelSky.displayName, "파스텔 스카이")
        XCTAssertEqual(SHTheme.pastelLemon.displayName, "파스텔 레몬")
    }

    func testButtonStyleCases() {
        XCTAssertEqual(SHButtonStyle.allCases.count, 5)
        XCTAssertTrue(SHButtonStyle.allCases.contains(.primary))
        XCTAssertTrue(SHButtonStyle.allCases.contains(.secondary))
        XCTAssertTrue(SHButtonStyle.allCases.contains(.ghost))
        XCTAssertTrue(SHButtonStyle.allCases.contains(.destructive))
        XCTAssertTrue(SHButtonStyle.allCases.contains(.glass))
    }

    func testButtonSizeCases() {
        XCTAssertEqual(SHButtonSize.allCases.count, 3)
        XCTAssertTrue(SHButtonSize.allCases.contains(.small))
        XCTAssertTrue(SHButtonSize.allCases.contains(.medium))
        XCTAssertTrue(SHButtonSize.allCases.contains(.large))
    }
}
