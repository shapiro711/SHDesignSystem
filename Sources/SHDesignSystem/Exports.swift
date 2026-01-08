// MARK: - SHDesignSystem Public Exports
// 이 파일은 라이브러리 사용자가 import SHDesignSystem 으로 접근할 수 있는
// 모든 public API를 정리합니다.

// Foundation
@_exported import struct SwiftUI.Color
@_exported import struct SwiftUI.Font

// Re-export commonly used types for convenience
// 사용자는 import SHDesignSystem 만으로 모든 컴포넌트에 접근 가능

/*
 Usage Example:

 import SHDesignSystem

 struct ContentView: View {
     @State private var text = ""
     @State private var isOn = false

     var body: some View {
         VStack(spacing: SH.spacing.md) {
             // Typography
             SHLabel("Welcome", style: .headline)

             // Buttons
             SHButton("Primary", style: .primary) { }
             SHButton("Secondary", style: .secondary) { }
             SHButton("Glass", style: .glass) { }

             // Input
             SHTextField("Enter text", text: $text, style: .glass)
             SHInputField("Email", text: $text, icon: "envelope")

             // Search
             SHSearchBar(text: $text, style: .glass)

             // Cards
             SHCard(style: .glass) {
                 Text("Card content")
             }

             // List Items
             SHNavigationListItem("Settings", icon: "gear") { }
             SHToggleListItem("Dark Mode", icon: "moon", isOn: $isOn)

             // Chips
             SHChip("Tag", style: .filled)
         }
         .padding()
         .shTheme(.pastelLavender)
     }
 }
 */
