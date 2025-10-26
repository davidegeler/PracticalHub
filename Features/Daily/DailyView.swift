import SwiftUI

struct DailyView: View {
    @StateObject private var viewModel = DailyViewModel()   // <— kein Init von außen
    
    private func weekdayTitle(for date: Date) -> String {
        let f = DateFormatter()
        f.locale = .current
        f.setLocalizedDateFormatFromTemplate("EEEE") // nur Wochentag
        return f.string(from: date).capitalized
    }


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // GROßER WOCHENTAGS-TITEL
                    Text(weekdayTitle(for: viewModel.snapshot.date))
                        .font(.system(size: 56, weight: .bold))
                        .padding(.vertical, 8)

                    // GYM CARD (Mo/Fr Upper, Mi/Sa Lower)
                    if viewModel.snapshot.hasGym, let t = viewModel.snapshot.training {
                        PillCard(
                            title: "Gym \(t.rawValue)",
                            imageName: t == .upperBody ? "daily_gym_upper" : "daily_gym_lower"
                        )
                    }

                    // SCHOOL CARD
                    if viewModel.snapshot.hasSchool {
                        PillCard(title: "School", imageName: "daily_school")
                    }

                    // OFFICE DAY CARD
                    if viewModel.snapshot.isOfficeDay {
                        PillCard(title: "Office Day", imageName: "daily_office")
                    }

                    // SPA DAY CARD (So)
                    if viewModel.snapshot.isSpaDay {
                        PillCard(title: "Spa Day (Sauna & Eisbad)", imageName: "daily_spa")
                    }

                    // LINK (Montag: BrandsForEmployees)
                    if let link = viewModel.snapshot.links.first,
                       let url = URL(string: link.urlString) {
                        Link(destination: url) {
                            PillCard(title: link.title, imageName: "brand_bfe")
                        }
                    }

                    // WETTER-LEISTE (Platzhalter-Icons; echte API später)
                    // WETTER-LEISTE (Platzhalter-Icons; echte API später)
                    // Wetter-Box (ohne Überschrift)
                    if !viewModel.snapshot.weather.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                WeatherChip(timeText: "08:00", systemImage: "cloud.sun")
                                WeatherChip(timeText: "10:00", systemImage: "cloud.rain")
                                WeatherChip(timeText: "12:00", systemImage: "cloud.rain")
                                WeatherChip(timeText: "14:00", systemImage: "cloud.heavyrain")
                                WeatherChip(timeText: "16:00", systemImage: "cloud.bolt.rain") // <-- neu hinzugefügt
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                            )
                            .shadow(radius: 1, y: 1)
                        }
                    }

                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .navigationTitle("Daily")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { Task { await viewModel.load() } } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .task { await viewModel.load() }
        }
    }

}
private struct PillCard: View {
    var title: String
    var imageName: String? = nil

    var body: some View {
        HStack(spacing: 8) { // kleiner Abstand zwischen Text & Icon
            Spacer()
            
            // Text + Icon zentriert als Gruppe
            HStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                if let name = imageName, UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.black, lineWidth: 1)
                )
        )
        .shadow(radius: 1, y: 1)
    }
}


private struct WeatherChip: View {
    var timeText: String
    var systemImage: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)   // Icon-Farbe unverändert (System/Theme)
                .imageScale(.large)
            Text(timeText)
                .font(.footnote)
                .foregroundColor(.black)     // nur Text schwarz
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.black, lineWidth: 1)
                )
        )
    }
}



