//
//  QuizResultsView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct QuizResultsView: View {
    @FetchRequest(entity: QuizResult.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \QuizResult.dateTaken, ascending: false)]) var results: FetchedResults<QuizResult>
    @FetchRequest(entity: Team.entity(), sortDescriptors: []) var teams: FetchedResults<Team>
    
    @State private var selectedTab = 1
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("View Mode", selection: $selectedTab) {
                    Text("Available Quizzes").tag(0)
                    Text("Results").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedTab == 0 {
                    List(teams.filter { $0.quiz != nil }, id: \.self) { team in
                        NavigationLink(destination: TeamDetailView(team: team)) {
                            HStack {
                                Text(team.name ?? "Unknown Team")
                                Spacer()
                                if team.isFavourite {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    List(results, id: \.self) { result in
                        VStack(alignment: .leading) {
                            Text("Date: \(result.dateTaken?.formatted(date: .long, time: .shortened) ?? "-")")
                            Text("Score: \(result.score)/\(result.totalQuestions)")
                                .font(.subheadline)
                            if let team = result.quiz?.team {
                                Text("Team: \(team.name ?? "")")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Quiz")
        }
    }
}
