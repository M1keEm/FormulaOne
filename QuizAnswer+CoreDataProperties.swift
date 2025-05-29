//
//  QuizAnswer+CoreDataProperties.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//
//

import Foundation
import CoreData


extension QuizAnswer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizAnswer> {
        return NSFetchRequest<QuizAnswer>(entityName: "QuizAnswer")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var quizquestion: QuizQuestion?

}

extension QuizAnswer : Identifiable {

}
