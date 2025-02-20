import Foundation
import CoreData

@objc(CoreDataPerson)
public class CoreDataPerson: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var age: String?
    @NSManaged public var children: NSSet
}

@objc(CoreDataChild)
public class CoreDataChild: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var age: String?
    @NSManaged public var parent: CoreDataPerson?
}

extension CoreDataPerson {
    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: CoreDataChild)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: CoreDataChild)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)
}

