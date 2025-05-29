//
//  QuizResult+CoreDataProperties.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//
//

import Foundation
import CoreData


extension QuizResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizResult> {
        return NSFetchRequest<QuizResult>(entityName: "QuizResult")
    }

    @NSManaged public var dateTaken: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var score: Int32
    @NSManaged public var totalQuestions: Int32
    @NSManaged public var driver: Driver?
    @NSManaged public var quiz: Quiz?

}

extension QuizResult : Identifiable {

}
