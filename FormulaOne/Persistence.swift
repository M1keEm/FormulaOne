//
//  Persistence.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 26/05/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FormulaOne")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        let shouldCreateTeams = !inMemory
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            if shouldCreateTeams {
                DispatchQueue.main.async {
                    PersistenceController.shared.createRealTeamsIfNeeded()
                }
            }
        }
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        return result
    }()
}

extension PersistenceController {
    func createRealTeamsIfNeeded() {
        let context = container.viewContext
        
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        request.predicate = NSPredicate(format: "name IN %@", ["Ferrari", "Red Bull Racing"])
        
        do {
            let existingTeams = try context.fetch(request)
            let existingNames = existingTeams.compactMap { $0.name }
            
            if !existingNames.contains("Ferrari") {
                createFerrari(in: context)
            }
            
            if !existingNames.contains("Red Bull Racing") {
                createRedBull(in: context)
            }
            
            try context.save()
        } catch {
            print("Failed to create real teams: \(error)")
        }
    }
    
    private func createFerrari(in context: NSManagedObjectContext) {
        let ferrari = Team(context: context)
        ferrari.id = UUID()
        ferrari.name = "Ferrari"
        ferrari.country = "Italy"
        ferrari.foundationYear = 1929
        ferrari.championships = 16
        ferrari.history = """
        Scuderia Ferrari is the oldest and most successful team in Formula 1 history.
        Founded by Enzo Ferrari in 1929, the team made its F1 debut in 1950.
        Ferrari has won 16 Constructors' Championships and 15 Drivers' Championships.
        The team is known for its passionate tifosi (fans) and iconic red cars.
        """
        ferrari.logoURL = "https://upload.wikimedia.org/wikipedia/en/thumb/d/d1/Scuderia_Ferrari_Logo.svg/1200px-Scuderia_Ferrari_Logo.svg.png"
        ferrari.isFavourite = false
        
        // Ferrari car
        let car = Car(context: context)
        car.id = UUID()
        car.model = "SF-23"
        car.engine = "Ferrari 066/10 V6 turbo hybrid"
        car.horsepower = 950
        car.topSpeed = 340
        car.productionYears = "2023"
        car.team = ferrari
        car.isFavourite = false
        
        // Ferrari drivers
        let leclerc = Driver(context: context)
        leclerc.id = UUID()
        leclerc.name = "Charles"
        leclerc.surname = "Leclerc"
        leclerc.nationality = "Monaco"
        leclerc.birthDate = Date(timeIntervalSince1970: 846374400) // 16 Oct 1997
        leclerc.championships = 0
        leclerc.wins = 5
        leclerc.podiums = 27
        leclerc.debutYear = 2018
        leclerc.biography = "Monegasque racing driver who joined Ferrari in 2019."
        leclerc.isFavourite = false
        leclerc.addToTeam(ferrari)
        
        let sainz = Driver(context: context)
        sainz.id = UUID()
        sainz.name = "Carlos"
        sainz.surname = "Sainz Jr."
        sainz.nationality = "Spain"
        sainz.birthDate = Date(timeIntervalSince1970: 715132800) // 1 Sep 1994
        sainz.championships = 0
        sainz.wins = 1
        sainz.podiums = 15
        sainz.debutYear = 2015
        sainz.biography = "Spanish driver known as the 'Smooth Operator'."
        sainz.isFavourite = false
        sainz.addToTeam(ferrari)
        
        createFerrariQuiz(for: ferrari, in: context)
    }
    
    private func createRedBull(in context: NSManagedObjectContext) {
        let redbull = Team(context: context)
        redbull.id = UUID()
        redbull.name = "Red Bull Racing"
        redbull.country = "Austria"
        redbull.foundationYear = 2005
        redbull.championships = 5
        redbull.history = """
        Red Bull Racing entered Formula 1 in 2005 after buying Jaguar Racing.
        The team dominated the 2010-2013 seasons with Sebastian Vettel,
        winning four consecutive Constructors' and Drivers' Championships.
        Known for their aggressive aerodynamics and innovative designs.
        """
        redbull.logoURL = "https://upload.wikimedia.org/wikipedia/en/thumb/7/7d/Red_Bull_Racing_logo.svg/1200px-Red_Bull_Racing_logo.svg.png"
        redbull.isFavourite = false
        
        // Red Bull car
        let car = Car(context: context)
        car.id = UUID()
        car.model = "RB19"
        car.engine = "Honda RBPTH001 V6 turbo hybrid"
        car.horsepower = 960
        car.topSpeed = 345
        car.productionYears = "2023"
        car.team = redbull
        car.isFavourite = false
        
        // Red Bull drivers
        let verstappen = Driver(context: context)
        verstappen.id = UUID()
        verstappen.name = "Max"
        verstappen.surname = "Verstappen"
        verstappen.nationality = "Netherlands"
        verstappen.birthDate = Date(timeIntervalSince1970: 887587200) // 30 Sep 1997
        verstappen.championships = 2
        verstappen.wins = 39
        verstappen.podiums = 92
        verstappen.debutYear = 2015
        verstappen.biography = "Youngest F1 driver in history and two-time World Champion."
        verstappen.isFavourite = false
        verstappen.addToTeam(redbull)
        
        let perez = Driver(context: context)
        perez.id = UUID()
        perez.name = "Sergio"
        perez.surname = "Pérez"
        perez.nationality = "Mexico"
        perez.birthDate = Date(timeIntervalSince1970: 615859200) // 26 Jan 1990
        perez.championships = 0
        perez.wins = 6
        perez.podiums = 35
        perez.debutYear = 2011
        perez.biography = "Mexican driver known for his tyre management skills."
        perez.isFavourite = false
        perez.addToTeam(redbull)
        
        createRedBullQuiz(for: redbull, in: context)
    }
    
    private func createFerrariQuiz(for team: Team, in context: NSManagedObjectContext) {
        let quiz = Quiz(context: context)
        quiz.id = UUID()
        quiz.team = team
        
        createQuestion(
            text: "In which year did Ferrari make its Formula 1 debut?",
            correctAnswer: "1950",
            wrongAnswers: ["1948", "1952", "1960"],
            quiz: quiz,
            context: context
        )
        
        createQuestion(
            text: "Which Ferrari driver has the most championship titles?",
            correctAnswer: "Michael Schumacher",
            wrongAnswers: ["Niki Lauda", "Alberto Ascari", "Kimi Räikkönen"],
            quiz: quiz,
            context: context
        )
        
        createQuestion(
            text: "How many Constructors' Championships has Ferrari won?",
            correctAnswer: "16",
            wrongAnswers: ["12", "18", "20"],
            quiz: quiz,
            context: context
        )
    }
    
    private func createRedBullQuiz(for team: Team, in context: NSManagedObjectContext) {
        let quiz = Quiz(context: context)
        quiz.id = UUID()
        quiz.team = team
        
        createQuestion(
            text: "In which year did Red Bull win its first championship?",
            correctAnswer: "2010",
            wrongAnswers: ["2009", "2011", "2012"],
            quiz: quiz,
            context: context
        )
        
        createQuestion(
            text: "Which Red Bull driver won four consecutive titles?",
            correctAnswer: "Sebastian Vettel",
            wrongAnswers: ["Max Verstappen", "Daniel Ricciardo", "Mark Webber"],
            quiz: quiz,
            context: context
        )
        
        createQuestion(
            text: "What was Red Bull's original team before entering F1?",
            correctAnswer: "Jaguar Racing",
            wrongAnswers: ["Stewart Grand Prix", "Minardi", "Toro Rosso"],
            quiz: quiz,
            context: context
        )
    }
    
    private func createQuestion(text: String, correctAnswer: String, wrongAnswers: [String], quiz: Quiz, context: NSManagedObjectContext) {
        let question = QuizQuestion(context: context)
        question.id = UUID()
        question.text = text
        question.quiz = quiz
        question.correctAnswerId = UUID()
        
        createAnswer(text: correctAnswer, isCorrect: true, question: question, correctId: question.correctAnswerId!)
        
        wrongAnswers.forEach { answer in
            createAnswer(text: answer, isCorrect: false, question: question, correctId: question.correctAnswerId!)
        }
    }
    
    private func createAnswer(text: String, isCorrect: Bool, question: QuizQuestion, correctId: UUID) {
        let answer = QuizAnswer(context: container.viewContext)
        answer.id = isCorrect ? correctId : UUID()
        answer.text = text
        answer.quizquestion = question
    }
}
