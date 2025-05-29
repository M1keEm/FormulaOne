//
//  Driver+CoreDataProperties.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//
//

import Foundation
import CoreData


extension Driver {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Driver> {
        return NSFetchRequest<Driver>(entityName: "Driver")
    }

    @NSManaged public var birthDate: Date?
    @NSManaged public var championships: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var imageName: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?
    @NSManaged public var nationality: String?
    @NSManaged public var podiums: Int32
    @NSManaged public var surname: String?
    @NSManaged public var wins: Int32
    @NSManaged public var biography: String?
    @NSManaged public var debutYear: Int32
    @NSManaged public var fastestLaps: Int32
    @NSManaged public var photoURL: String?
    @NSManaged public var team: NSSet?
    @NSManaged public var car: NSSet?

}

// MARK: Generated accessors for team
extension Driver {

    @objc(addTeamObject:)
    @NSManaged public func addToTeam(_ value: Team)

    @objc(removeTeamObject:)
    @NSManaged public func removeFromTeam(_ value: Team)

    @objc(addTeam:)
    @NSManaged public func addToTeam(_ values: NSSet)

    @objc(removeTeam:)
    @NSManaged public func removeFromTeam(_ values: NSSet)

}

// MARK: Generated accessors for car
extension Driver {

    @objc(addCarObject:)
    @NSManaged public func addToCar(_ value: Car)

    @objc(removeCarObject:)
    @NSManaged public func removeFromCar(_ value: Car)

    @objc(addCar:)
    @NSManaged public func addToCar(_ values: NSSet)

    @objc(removeCar:)
    @NSManaged public func removeFromCar(_ values: NSSet)

}

extension Driver : Identifiable {

}
