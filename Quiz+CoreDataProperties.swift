//
//  Quiz+CoreDataProperties.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//
//

import Foundation
import CoreData


extension Quiz {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quiz> {
        return NSFetchRequest<Quiz>(entityName: "Quiz")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var questions: NSSet?
    @NSManaged public var results: NSSet?
    @NSManaged public var team: Team?

}

// MARK: Generated accessors for questions
extension Quiz {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: QuizQuestion)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: QuizQuestion)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}

// MARK: Generated accessors for results
extension Quiz {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: QuizResult)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: QuizResult)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}

extension Quiz : Identifiable {

}
