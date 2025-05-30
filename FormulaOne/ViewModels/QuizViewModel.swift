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
        guard let quiz = team.quiz,
              let questionsSet = quiz.questions as? Set<QuizQuestion> else {
            print("No quiz or questions found for team")
            return
        }
        
        questions = Array(questionsSet)
        print("Loaded \(questions.count) questions") // Debug
    }

    func submitQuiz(for driver: Driver, from quiz: Quiz) {
        let result = QuizResult(context: context)
        result.id = UUID()
        result.dateTaken = Date()
        result.driver = driver
        result.quiz = quiz
        result.score = Int32(calculateScore())
        result.totalQuestions = Int32(questions.count)
        
        do {
            try context.save()
            print("Quiz result saved successfully")
        } catch {
            print("Failed to save quiz result: \(error)")
        }
    }

    func calculateScore() -> Int {
        questions.filter { q in
            selectedAnswers[q.id!] == q.correctAnswerId
        }.count
    }
}
