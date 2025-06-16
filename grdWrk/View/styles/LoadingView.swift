import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            BackgroundLinearGradient()
            
            Image(systemName: "clock.fill")
                .foregroundColor(.green)
                .font(.system(size: 80))
                .frame(width: 80, height: 80)
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(25)
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        LoadingView()
    }
    .ignoresSafeArea()
}

