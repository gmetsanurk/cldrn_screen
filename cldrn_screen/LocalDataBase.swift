import CoreData
import Foundation

class CoreDataManager {
    public static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
/*
class CoreDataManager {
    public static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deletePersonAndChildren(person: CoreDataPerson) {
        context.delete(person)
        saveContext()
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public func logCoreDataDBPath() {
        if let url = persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print("DataBase URL - \(url)")
        }
    }
    
    private func coreDataIsEmpty() async -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        fetchRequest.fetchLimit = 1
        do {
            let count = try context.count(for: fetchRequest)
            return count == 0
        } catch {
            print("Check Error")
            return true
        }
    }
    
    func deletePerson(person: CoreDataPerson) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataPerson")
        fetchRequest.predicate = NSPredicate(format: "name == %@", person.name)
        
        do {
            let people = try context.fetch(fetchRequest)
            if let personToDelete = people.first as? CoreDataPerson {
                for child in personToDelete.children {
                    (child as? CoreDataChild)?.parent = nil
                }
                context.delete(personToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete person: \(error)")
        }
    }
    
}*/
