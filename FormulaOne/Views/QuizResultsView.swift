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
    @State private var showAnswersSheet = false
    @State private var selectedResult: QuizResult?
    
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
                        .onLongPressGesture {
                            selectedResult = result
                            showAnswersSheet = true
                        }
                    }
                    .listStyle(.plain)
                    .sheet(isPresented: $showAnswersSheet) {
                        if let questions = selectedResult?.quiz?.questions?.allObjects as? [QuizQuestion] {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(questions, id: \.self) { question in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Q: \(question.text ?? "")")
                                                .fontWeight(.bold)
                                            if let answers = question.answers?.allObjects as? [QuizAnswer],
                                               let correctID = question.correctAnswerId {
                                                if let correctAnswer = answers.first(where: { $0.id == correctID }) {
                                                    Text("✔ Correct: \(correctAnswer.text ?? "")")
                                                        .foregroundColor(.green)
                                                }
                                            }
                                        }
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                    }
                                }
                                .padding()
                            }
                        } else {
                            Text("No questions available.")
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Quiz")
        }
    }
}
