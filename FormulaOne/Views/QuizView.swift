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
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var showResult = false
    @State private var score = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Quiz o \(team.name ?? "Zespole")")
                    .font(.largeTitle).bold()

                ForEach(viewModel.questions, id: \.self) { question in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question.text ?? "Brak pytania")
                            .font(.headline)

                        if let answers = question.answers as? Set<QuizAnswer> {
                            ForEach(Array(answers).sorted(by: { $0.text ?? "" < $1.text ?? "" }), id: \.self) { answer in
                                Button(action: {
                                    viewModel.selectedAnswers[question.id!] = answer.id
                                }) {
                                    HStack {
                                        Image(systemName: viewModel.selectedAnswers[question.id!] == answer.id ? "largecircle.fill.circle" : "circle")
                                            .foregroundColor(.blue)
                                        Text(answer.text ?? "")
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }

                Button("Zakończ quiz") {
                    if let driver = try? context.fetch(Driver.fetchRequest()).first as? Driver,
                       let quiz = team.quiz {
                        viewModel.submitQuiz(for: driver, from: quiz)
                        score = viewModel.calculateScore()
                        showResult = true
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            viewModel.loadQuiz(for: team)
        }
        .alert("Wynik quizu", isPresented: $showResult) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Zdobyto \(score) z \(viewModel.questions.count) punktów.")
        }
    }
}