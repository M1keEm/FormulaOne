//
//  QuizViewModel.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//

import Foundation
import CoreData

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var selectedAnswers: [UUID: UUID] = [:]
    let context = PersistenceController.shared.container.viewContext

    func loadQuiz(for team: Team) {
        if let quizSet = team.value(forKey: "quiz") as? Set<Quiz>,
           let quiz = quizSet.first,
           let quizQuestions = quiz.questions as? Set<QuizQuestion> {
            questions = Array(quizQuestions)
        }
    }

    func submitQuiz(for driver: Driver, from quiz: Quiz) {
        let result = QuizResult(context: context)
        result.id = UUID()
        result.dateTaken = Date()
        result.driver = driver
        result.quiz = quiz
        result.score = Int32(calculateScore())
        result.totalQuestions = Int32(questions.count)
        try? context.save()
    }

    private func calculateScore() -> Int {
        questions.filter { q in
            selectedAnswers[q.id!] == q.correctAnswerId
        }.count
    }
}
