//
//  QuizQuestion+CoreDataProperties.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//
//

import Foundation
import CoreData


extension QuizQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizQuestion> {
        return NSFetchRequest<QuizQuestion>(entityName: "QuizQuestion")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var correctAnswerId: UUID?
    @NSManaged public var quiz: Quiz?
    @NSManaged public var answers: NSSet?

}

// MARK: Generated accessors for answers
extension QuizQuestion {

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: QuizAnswer)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: QuizAnswer)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSSet)

}

extension QuizQuestion : Identifiable {

}
