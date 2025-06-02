//
//  QuizResultsView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//

import SwiftUI

struct QuizResultsView: View {
    private static let quizSortDescriptors = [
        NSSortDescriptor(keyPath: \QuizResult.dateTaken, ascending: false)
    ]

    @FetchRequest(
        entity: QuizResult.entity(),
        sortDescriptors: quizSortDescriptors
    ) var results: FetchedResults<QuizResult>
    @FetchRequest(entity: Team.entity(), sortDescriptors: []) var teams:
        FetchedResults<Team>

    @State private var selectedTab = 1
    @State private var showAnswersSheet = false
    @State private var selectedResult: QuizResult?
    @State private var sortedResults: [QuizResult] = []

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
                        NavigationLink(destination: TeamDetailView(team: team))
                        {
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
                    List(sortedResults, id: \.self) { result in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Date: \(result.dateTaken?.formatted(date: .long, time: .shortened) ?? "-")")
                                if result.isPinned {
                                    Image(systemName: "pin.fill")
                                        .foregroundColor(.orange)
                                }
                            }
                            Text(
                                "Score: \(result.score)/\(result.totalQuestions)"
                            )
                            .font(.subheadline)
                            if let team = result.quiz?.team {
                                Text("Team: \(team.name ?? "")")
                                    .font(.subheadline)
                            }
                        }
                        .simultaneousGesture(
                            TapGesture(count: 2)
                                .onEnded {
                                    result.isPinned.toggle()
                                    try? result.managedObjectContext?.save()
                                    updateSortedResults()
                                }
                        )
                        .onLongPressGesture {
                            selectedResult = result
                            showAnswersSheet = true
                        }
                    }
                    .listStyle(.plain)
                    .onAppear {
                        updateSortedResults()
                    }
                    .sheet(isPresented: $showAnswersSheet) {
                        if let questions = selectedResult?.quiz?.questions?
                            .allObjects as? [QuizQuestion]
                        {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(questions, id: \.self) { question in
                                        VStack(alignment: .leading, spacing: 4)
                                        {
                                            Text("Q: \(question.text ?? "")")
                                                .fontWeight(.bold)
                                            if let answers = question.answers?
                                                .allObjects as? [QuizAnswer],
                                                let correctID = question
                                                    .correctAnswerId
                                            {
                                                if let correctAnswer =
                                                    answers.first(where: {
                                                        $0.id == correctID
                                                    })
                                                {
                                                    Text(
                                                        "✔ Correct: \(correctAnswer.text ?? "")"
                                                    )
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

    private func updateSortedResults() {
        sortedResults = results.sorted(by: compareResults)
    }

    private func compareResults(_ lhs: QuizResult, _ rhs: QuizResult) -> Bool {
        if lhs.isPinned != rhs.isPinned {
            return lhs.isPinned && !rhs.isPinned
        } else {
            return (lhs.dateTaken ?? .distantPast)
                > (rhs.dateTaken ?? .distantPast)
        }
    }
}
