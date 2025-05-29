//
//  Team+CoreDataProperties.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var championships: Int32
    @NSManaged public var foundationYear: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var logoURL: String?
    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var history: String?
    @NSManaged public var drivers: NSSet?
    @NSManaged public var quiz: Quiz?

}

// MARK: Generated accessors for drivers
extension Team {

    @objc(addDriversObject:)
    @NSManaged public func addToDrivers(_ value: Driver)

    @objc(removeDriversObject:)
    @NSManaged public func removeFromDrivers(_ value: Driver)

    @objc(addDrivers:)
    @NSManaged public func addToDrivers(_ values: NSSet)

    @objc(removeDrivers:)
    @NSManaged public func removeFromDrivers(_ values: NSSet)

}

extension Team : Identifiable {

}
