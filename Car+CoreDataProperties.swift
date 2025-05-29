//
//  Car+CoreDataProperties.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var engine: String?
    @NSManaged public var horsepower: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var photoURL: String?
    @NSManaged public var model: String?
    @NSManaged public var topSpeed: Int32
    @NSManaged public var productionYears: String?
    @NSManaged public var maxSpeed: Int32
    @NSManaged public var isFavourite: Bool
    @NSManaged public var driver: NSSet?
    @NSManaged public var team: Team?

}

// MARK: Generated accessors for driver
extension Car {

    @objc(addDriverObject:)
    @NSManaged public func addToDriver(_ value: Driver)

    @objc(removeDriverObject:)
    @NSManaged public func removeFromDriver(_ value: Driver)

    @objc(addDriver:)
    @NSManaged public func addToDriver(_ values: NSSet)

    @objc(removeDriver:)
    @NSManaged public func removeFromDriver(_ values: NSSet)

}

extension Car : Identifiable {

}
