//
//  Persistence.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 26/05/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Podgląd z testowymi danymi
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        addSampleData(to: viewContext)
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FormulaOne")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true

        // Dodaj dane testowe tylko przy normalnym uruchomieniu (np. pierwszy raz)
        if !inMemory && container.viewContext.hasChanges == false {
            PersistenceController.addSampleData(to: container.viewContext)
        }
    }

    // MARK: - Przykładowe dane
    static func addSampleData(to context: NSManagedObjectContext) {
        for i in 1...2 {
            let team = Team(context: context)
            team.id = UUID()
            team.name = "Team \(i)"
            team.country = "Country \(i)"
            team.championships = Int32(i)
            team.foundationYear = 1950 + Int32(i)
            team.isFavourite = false
            team.history = "Historia Team \(i)"

            let driver = Driver(context: context)
            driver.id = UUID()
            driver.name = "Driver \(i)"
            driver.surname = "Surname \(i)"
            driver.nationality = "Nationality \(i)"
            driver.birthDate = Calendar.current.date(byAdding: .year, value: -25 - i, to: Date())
            driver.podiums = Int32(i * 3)
            driver.wins = Int32(i * 2)
            driver.championships = Int32(i)
            driver.debutYear = 2000 + Int32(i)
            driver.biography = "Biografia Driver \(i)"
            driver.isFavourite = false

            let car = Car(context: context)
            car.id = UUID()
            car.model = "Model \(i)"
            car.engine = "V8 Turbo"
            car.horsepower = 950 + Int32(i * 10)
            car.topSpeed = 340 + Int32(i * 5)
            car.productionYears = "201\(i)-201\(i+1)"
            car.isFavourite = false

            // Relacje
            driver.addToCar(car)
            team.addToDrivers(driver)
            car.team = team

            // Quiz
            let quiz = Quiz(context: context)
            quiz.id = UUID()
            quiz.team = team

            let question = QuizQuestion(context: context)
            question.id = UUID()
            question.text = "W którym roku powstał \(team.name ?? "ten zespół")?"
            question.quiz = quiz

            let answer1 = QuizAnswer(context: context)
            answer1.id = UUID()
            answer1.text = "\(team.foundationYear)"
            answer1.quizquestion = question

            let answer2 = QuizAnswer(context: context)
            answer2.id = UUID()
            answer2.text = "2000"
            answer2.quizquestion = question

            question.correctAnswerId = answer1.id
            question.answers = NSSet(array: [answer1, answer2])
            quiz.questions = NSSet(array: [question])
            team.quiz = quiz
        }

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("❌ Nie udało się zapisać przykładowych danych: \(nsError), \(nsError.userInfo)")
        }
    }
}
extension PersistenceController {
    func createSampleQuiz(for team: Team) {
        let context = container.viewContext
        
        let quiz = Quiz(context: context)
        quiz.id = UUID()
        quiz.team = team
        
        // Question 1
        let question1 = QuizQuestion(context: context)
        question1.id = UUID()
        question1.text = "In what year did \(team.name ?? "the team") win its first championship?"
        question1.quiz = quiz
        question1.correctAnswerId = UUID()
        
        // Answers for question 1
        createAnswer(text: "2005", isCorrect: false, question: question1, correctId: question1.correctAnswerId!)
        createAnswer(text: "2010", isCorrect: false, question: question1, correctId: question1.correctAnswerId!)
        createAnswer(text: "2012", isCorrect: true, question: question1, correctId: question1.correctAnswerId!)
        
        // Question 2
        let question2 = QuizQuestion(context: context)
        question2.id = UUID()
        question2.text = "Who was the main driver for \(team.name ?? "the team") in 2020 season?"
        question2.quiz = quiz
        question2.correctAnswerId = UUID()
        
        // Answers for question 2
        createAnswer(text: "John Smith", isCorrect: true, question: question2, correctId: question2.correctAnswerId!)
        createAnswer(text: "Michael Johnson", isCorrect: false, question: question2, correctId: question2.correctAnswerId!)
        createAnswer(text: "Robert Williams", isCorrect: false, question: question2, correctId: question2.correctAnswerId!)
        
        // Question 3
        let question3 = QuizQuestion(context: context)
        question3.id = UUID()
        question3.text = "How many constructor championships has \(team.name ?? "the team") won?"
        question3.quiz = quiz
        question3.correctAnswerId = UUID()
        
        // Answers for question 3
        createAnswer(text: "3", isCorrect: false, question: question3, correctId: question3.correctAnswerId!)
        createAnswer(text: "5", isCorrect: true, question: question3, correctId: question3.correctAnswerId!)
        createAnswer(text: "7", isCorrect: false, question: question3, correctId: question3.correctAnswerId!)
        
        do {
            try context.save()
            print("Quiz created for \(team.name ?? "team")")
        } catch {
            print("Failed to save quiz: \(error)")
        }
    }
    
    private func createAnswer(text: String, isCorrect: Bool, question: QuizQuestion, correctId: UUID) {
        let answer = QuizAnswer(context: container.viewContext)
        answer.id = isCorrect ? correctId : UUID()
        answer.text = text
        answer.quizquestion = question
    }
}
