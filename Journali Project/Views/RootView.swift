import SwiftUI

struct RootView: View {
    @State private var isActive = false
    @State private var viewModel = JournalViewModel()

    var body: some View {
        Group {
            if isActive {
                MainPageView(viewModel: viewModel)
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
        }
    }
}

// مُحوّل الألوان (موجود هنا فقط، وتأكد أنه غير موجود بأي ملف آخر)
extension Color {
    init(hexString: String) {
        let scanner = Scanner(string: hexString)
        _ = scanner.scanString("#")
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
