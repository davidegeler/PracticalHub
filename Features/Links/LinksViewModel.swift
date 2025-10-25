import Foundation
import Combine


struct QuickLink: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var url: URL
    var group: String?
}

final class LinksViewModel: ObservableObject {
    @Published var links: [QuickLink] = [
        .init(title: "GitHub", url: URL(string: "https://github.com")!, group: "Dev"),
        .init(title: "Mail", url: URL(string: "https://mail.google.com")!, group: "Work")
    ]
    func addLink(_ link: QuickLink) { links.append(link) }
    func remove(at offsets: IndexSet) {
        for i in offsets.sorted(by: >) { links.remove(at: i) }
    }

}
