//
//  DailyTrainingPopup.swift
//  PracticalHub
//
//  Created by David Egeler on 26.10.2025.
//
import SwiftUI
import UIKit
import Combine

// MARK: - Domain

enum Weekday: Int, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    static func from(_ date: Date) -> Weekday {
        let cal = Calendar(identifier: .gregorian)
        let tz = TimeZone(identifier: "Europe/Zurich") ?? .current
        var comps = cal.dateComponents(in: tz, from: date)
        let weekdayNumber = comps.calendar?.component(.weekday, from: date) ?? 1
        return Weekday(rawValue: weekdayNumber) ?? .monday
    }

    var displayName: String {
        switch self {
        case .monday: return "Montag"
        case .tuesday: return "Dienstag"
        case .wednesday: return "Mittwoch"
        case .thursday: return "Donnerstag"
        case .friday: return "Freitag"
        case .saturday: return "Samstag"
        case .sunday: return "Sonntag"
        }
    }
}

struct TrainingExercise: Identifiable {
    let id = UUID()
    let name: String
    let setsReps: String
}

struct TrainingSession {
    let day: Weekday
    let title: String
    let exercises: [TrainingExercise]
}

final class TrainingPlanner: ObservableObject {
    // Deine Pläne (aus der Anfrage übernommen)
    private let sessions: [Weekday: TrainingSession] = [
        .monday: TrainingSession(
            day: .monday,
            title: "Upper Push/Pull",
            exercises: [
                .init(name: "Bench Press", setsReps: "4×6–8"),
                .init(name: "Pull Ups", setsReps: "4×8–10"),
                .init(name: "Shoulder Press", setsReps: "3×8–10"),
                .init(name: "Rows", setsReps: "3×8–10"),
                .init(name: "Incline Bench Press", setsReps: "3×10"),
                .init(name: "Face Pulls", setsReps: "3×15")
            ]
        ),
        .wednesday: TrainingSession(
            day: .wednesday,
            title: "Lower + Core",
            exercises: [
                .init(name: "Squats", setsReps: "4×8"),
                .init(name: "Lunges", setsReps: "3×10"),
                .init(name: "Leg Extensions", setsReps: "3×12"),
                .init(name: "Calve Raises", setsReps: "3×15–20"),
                .init(name: "Hanging Leg Raises", setsReps: "3×12–15")
            ]
        ),
        .friday: TrainingSession(
            day: .friday,
            title: "Upper Volumen",
            exercises: [
                .init(name: "Incline Bench Press", setsReps: "4×12–15"),
                .init(name: "Rows", setsReps: "4×10–12"),
                .init(name: "Shoulder Press", setsReps: "3×12"),
                .init(name: "Lat Pull (wide)", setsReps: "3×12"),
                .init(name: "Shoulder Raise", setsReps: "3×15"),
                .init(name: "Dips/Curls", setsReps: "2×12")
            ]
        ),
        .saturday: TrainingSession(
            day: .saturday,
            title: "Posterior Chain + Core",
            exercises: [
                .init(name: "Romanian Deadlift", setsReps: "4×8"),
                .init(name: "Bulgarian Split Squats", setsReps: "3×10"),
                .init(name: "Leg Curls", setsReps: "3×10"),
                .init(name: "Calve Press", setsReps: "3×15"),
                .init(name: "Cable Crunch", setsReps: "3×15")
            ]
        )
    ]

    func session(for date: Date = Date()) -> TrainingSession? {
        sessions[Weekday.from(date)]
    }
}

// MARK: - Views

struct TrainingPopupView: View {
    let session: TrainingSession
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            // Hintergrund-Dim
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            // Card
            VStack(spacing: 0) {
                HStack {
                    Text("\(session.day.displayName) • \(session.title)")
                        .font(.title3.weight(.semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .padding(8)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Schließen")
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 8)

                Divider().opacity(0.2)

                // Minimalistische Liste
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(session.exercises) { ex in
                            HStack(alignment: .firstTextBaseline) {
                                Text(ex.name)
                                    .font(.body)
                                Spacer()
                                Text(ex.setsReps)
                                    .font(.callout.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.thinMaterial)
                            )
                        }
                    }
                    .padding(14)
                }
                .frame(maxHeight: 420)

                // kleine Fußzeile
                HStack {
                    Image(systemName: "bolt.heart")
                    Text("Clean • Fokus • Technik")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 30, y: 10)
            )
            .padding(.horizontal, 18)
            .transition(.scale.combined(with: .opacity))
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isPresented)
    }
}

struct DailyTrainingCard: View {
    @StateObject private var planner = TrainingPlanner()
    @State private var showPopup = false

    var body: some View {
        let todaySession = planner.session()

        Button {
            if todaySession != nil {
                // optional haptics
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showPopup = true
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "dumbbell")
                    .imageScale(.large)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Heutiges Training")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(todaySession != nil
                         ? "\(todaySession!.day.displayName): \(todaySession!.title)"
                         : "Rest / Mobility")
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                Spacer()
                Image(systemName: "chevron.up")
                    .rotationEffect(.degrees(showPopup ? 180 : 0))
                    .animation(.easeInOut(duration: 0.2), value: showPopup)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.thinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.white.opacity(0.08))
            )
        }
        .buttonStyle(.plain)
        .overlay {
            if showPopup, let s = todaySession {
                TrainingPopupView(session: s, isPresented: $showPopup)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}

