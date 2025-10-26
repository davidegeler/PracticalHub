import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            DailyView()
                .tabItem { Label("Daily", systemImage: "sun.max") }

            LinksView(viewModel: .init())
                .tabItem { Label("Links", systemImage: "link") }

            LoLView(viewModel: .init())
                .tabItem { Label("LoL", systemImage: "gamecontroller") }
        }
    }
}
