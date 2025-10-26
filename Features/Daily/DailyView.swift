//
//  DailyView.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//

import SwiftUI
import UIKit

struct DailyView: View {
    @StateObject private var viewModel = DailyViewModel()

    // MARK: - Helpers
    private func weekdayTitle(for date: Date) -> String {
        let f = DateFormatter()
        f.locale = .current
        f.setLocalizedDateFormatFromTemplate("EEEE")
        return f.string(from: date).capitalized
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {

                    // Titel
                    Text(weekdayTitle(for: viewModel.snapshot.date))
                        .font(.system(size: 56, weight: .bold))
                        .padding(.vertical, 8)

                    // Wetterleiste
                    weatherStrip

                    // Gym-Card
                    if viewModel.snapshot.hasGym, let t = viewModel.snapshot.training {
                        GymPillWithPopup(
                            date: viewModel.snapshot.date,
                            title: "Gym \(t.rawValue)",
                            imageName: t == .upperBody ? "daily_gym_upper" : "daily_gym_lower"
                        )
                    }

                    // School
                    if viewModel.snapshot.hasSchool {
                        PillCard(title: "School", imageName: "daily_school")
                    }

                    // Office
                    if viewModel.snapshot.isOfficeDay {
                        PillCard(title: "Office Day", imageName: "daily_office")
                    }

                    // Spa
                    if viewModel.snapshot.isSpaDay {
                        PillCard(title: "Spa Day (Sauna & Eisbad)", imageName: "daily_spa")
                    }

                    // Link
                    if let link = viewModel.snapshot.links.first,
                       let url = URL(string: link.urlString) {
                        Link(destination: url) {
                            PillCard(title: link.title, imageName: "brand_bfe")
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .navigationTitle("Daily")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.load()
                            await viewModel.loadWeather()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .task {
                await viewModel.load()
                await viewModel.loadWeather()
            }
        }
    }

    // MARK: - Wetter-Strip
    private var weatherStrip: some View {
        Group {
            if let w = viewModel.cityWeather {
                HStack(spacing: 8) {
                    if let c = w.currentCode, let t = w.currentTemp {
                        Image(systemName: WeatherSymbols.name(for: c))
                            .imageScale(.small)
                            .font(.caption)
                        Text("\(Int(round(t)))°")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Divider().frame(height: 12)

                    ForEach(w.days.prefix(3)) { day in
                        VStack(spacing: 2) {
                            Text(day.date, format: .dateTime.weekday(.abbreviated))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Image(systemName: WeatherSymbols.name(for: day.weatherCode))
                                .imageScale(.small)
                                .font(.caption)
                            Text("\(Int(day.tMin))–\(Int(day.tMax))°")
                                .font(.caption2)
                        }
                        .frame(minWidth: 42)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            } else if viewModel.isLoadingWeather {
                ProgressView().scaleEffect(0.8)
            } else if let e = viewModel.weatherError {
                Label {
                    Text(e).font(.caption2)
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                .foregroundStyle(.secondary)
            } else {
                EmptyView()
            }
        }
    }
}

// MARK: - Lokale UI-Komponenten
private struct PillCard: View {
    var title: String
    var imageName: String?

    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
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
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.black, lineWidth: 1)
                )
        )
        .shadow(radius: 1, y: 1)
    }
}

private struct GymPillWithPopup: View {
    let date: Date
    let title: String
    let imageName: String

    @State private var showPopup = false
    private let planner = DTPlanner() // aus DailyTrainingKit

    var body: some View {
        let daySession = planner.session(for: date)

        Button {
            if daySession != nil { showPopup = true }
        } label: {
            PillCard(title: title, imageName: imageName)
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $showPopup) {
            if let s = daySession {
                DTTrainingPopupView(session: s, isPresented: $showPopup)
                    .ignoresSafeArea()
            }
        }
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView()
            .preferredColorScheme(.light)
        DailyView()
            .preferredColorScheme(.dark)
    }
}
