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
                Text("\(team.name ?? "Team") Quiz")
                    .font(.largeTitle).bold()
                
                if viewModel.questions.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                    Text("Loading questions...")
                        .frame(maxWidth: .infinity)
                } else {
                    ForEach(viewModel.questions, id: \.id) { question in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(question.text ?? "Question text missing")
                                .font(.headline)
                            
                            if let answers = question.answers?.allObjects as? [QuizAnswer] {
                                ForEach(answers, id: \.id) { answer in
                                    Button(action: {
                                        viewModel.selectedAnswers[question.id!] = answer.id
                                    }) {
                                        HStack {
                                            Image(systemName: viewModel.selectedAnswers[question.id!] == answer.id ?
                                                  "largecircle.fill.circle" : "circle")
                                                .foregroundColor(.blue)
                                            Text(answer.text ?? "Answer missing")
                                            Spacer()
                                        }
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    Button("Submit Quiz") {
                        if let driver = try? context.fetch(Driver.fetchRequest()).first as? Driver {
                            viewModel.submitQuiz(for: driver, from: team.quiz!)
                            score = viewModel.calculateScore()
                            showResult = true
                        }
                    }
                    .disabled(viewModel.selectedAnswers.count != viewModel.questions.count)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.loadQuiz(for: team)
        }
        .alert("Quiz Results", isPresented: $showResult) {
            Button("OK") { dismiss() }
        } message: {
            Text("You scored \(score) out of \(viewModel.questions.count)")
        }
    }
}
