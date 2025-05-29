//
//  QuizView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct QuizView: View {
    @ObservedObject var viewModel: QuizViewModel
    var team: Team

    var body: some View {
        VStack {
            Text("Quiz: \(team.name ?? "Zespół")")
                .font(.title)

            ForEach(viewModel.questions, id: \.self) { question in
                VStack(alignment: .leading) {
                    Text(question.text ?? "")
                        .font(.headline)
                    if let answers = question.answers as? Set<QuizAnswer> {
                        ForEach(Array(answers), id: \.self) { answer in
                            Button(action: {
                                viewModel.selectedAnswers[question.id!] = answer.id
                            }) {
                                HStack {
                                    Text(answer.text ?? "")
                                    if viewModel.selectedAnswers[question.id!] == answer.id {
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Button("Submit Quiz") {
                if let driver = try? PersistenceController.shared.container.viewContext.fetch(Driver.fetchRequest()).first,
                   let quiz = team.value(forKey: "quiz") as? Set<Quiz>, let q = quiz.first {
                    viewModel.submitQuiz(for: driver as! Driver, from: q)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.loadQuiz(for: team)
        }
    }
}