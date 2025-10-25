import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            DailyView(viewModel: .init())
                .tabItem { Label("Daily", systemImage: "sun.max") }

            LinksView(viewModel: .init())
                .tabItem { Label("Links", systemImage: "link") }

            LoLView(viewModel: .init())
                .tabItem { Label("LoL", systemImage: "gamecontroller") }
        }
    }
}
