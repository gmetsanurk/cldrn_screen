import Foundation
import CoreData

struct Person {
    let id: UUID?
    let name: String?
    let age: String?
    let children: Set<Child>
}

extension Person {
    init(model: CoreDataPerson, children: Set<Child>) {
        self.id = model.personId
        self.name = model.name
        self.age = model.age
        self.children = children
    }
}

struct Child: Hashable {
    let id: UUID?
    let name: String?
    let age: String?
}

extension Child {
    init(model: CoreDataChild) {
        self.id = model.childId
        self.name = model.name
        self.age = model.age
    }
}



@objc(CoreDataPerson)
public class CoreDataPerson: NSManagedObject {
    @NSManaged public var personId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var age: String?
}

@objc(CoreDataChild)
public class CoreDataChild: NSManagedObject {
    @NSManaged public var childId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var age: String?
    @NSManaged public var parentId: UUID?
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

