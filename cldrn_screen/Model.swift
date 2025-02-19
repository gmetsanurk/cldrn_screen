import Foundation
import CoreData

struct Person {
    var name: String
    var age: String
    var children: [Child]
}

struct Child {
    var name: String
    var age: String
}

@objc(CoreDataPerson)
public class CoreDataPerson: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var age: String
    @NSManaged public var children: Set<CoreDataChild>
}

@objc(Child)
public class CoreDataChild: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var age: String
    @NSManaged public var parent: CoreDataPerson?
}

