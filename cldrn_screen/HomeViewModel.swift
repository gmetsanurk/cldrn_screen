import UIKit
import CoreData

class HomeViewModel {
    
    weak var viewController: HomeScreen?
    
    private let maxChildrenCount = 5
    private var person: Person?
    private var coreDataPerson: CoreDataPerson?
    private var tempChildren: [CoreDataChild] = []
    
    init(viewController: HomeScreen) {
        self.viewController = viewController
    }
    
    func loadData() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<CoreDataPerson> = CoreDataPerson.fetchRequest() as! NSFetchRequest<CoreDataPerson>
        
        let fetchChildrenRequest: NSFetchRequest<CoreDataChild> = CoreDataChild.fetchRequest() as! NSFetchRequest<CoreDataChild>
        
        do {
            let people = try context.fetch(fetchRequest)
            self.coreDataPerson = people.first
            tempChildren = try context.fetch(fetchChildrenRequest)
            
            let childrenForParent = Set(tempChildren.filter {
                $0.parentId == coreDataPerson?.personId // This does not affect anything(
            }.map {
                Child(model: $0)
            })
            
            self.person = .init(id: coreDataPerson?.personId, name: coreDataPerson?.name, age: coreDataPerson?.age, children: childrenForParent)
            
            DispatchQueue.main.async {
                self.viewController?.reloadCollectionView()
            }
            
            print("person: \(self.person?.name ?? "no name"), children: \(self.tempChildren.count)")
        } catch {
            print("Data load error: \(error.localizedDescription)")
        }
    }
    
    func updatePersonData(from cell: PersonCell) {
        if coreDataPerson == nil {
            coreDataPerson = CoreDataPerson(context: CoreDataManager.shared.context)
        }
        coreDataPerson!.name = cell.nameTextField.text ?? ""
        coreDataPerson!.age = cell.ageTextField.text ?? ""
        person = .init(model: coreDataPerson!, children: .init())
        saveData()
    }
    
    func updateChildData(from cell: ChildCell, at index: Int) {
        tempChildren[index].name = cell.nameTextField.text ?? "no_name"
        tempChildren[index].age = cell.ageTextField.text ?? "0"
        saveData()
    }
    
    func addChild() {
        guard let viewController = viewController else { return }
        let context = CoreDataManager.shared.context
        
        if let personCell = viewController.returnPersonCell() {
            updatePersonData(from: personCell as! PersonCell)
        }
        
        guard let person = person else {
            print("Error: Person is not found")
            return
        }
        
        if tempChildren.count >= maxChildrenCount {
            print("Max children")
            return
        }
        
        let newChild = CoreDataChild(context: context)
        newChild.name = "new name"
        newChild.age = "0"
        newChild.parentId = coreDataPerson?.personId
        
        tempChildren.append(newChild)
        saveData()
    }
    
    func deleteChild(at index: Int) {
        let childToDelete = tempChildren[index]
        CoreDataManager.shared.context.delete(childToDelete)
        tempChildren.remove(at: index)
        saveData()
    }
    
    func deletePerson() {
        deleteAllData()
        saveData()
        loadData()
    }
    
    private func deleteAllData() {
        let context = CoreDataManager.shared.context
        let entityNames = ["CoreDataPerson", "CoreDataChild"]
        
        do {
            for entity in entityNames {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteRequest)
            }
            context.reset()
            try context.save()
        } catch {
            print("Errror deleting data: \(error.localizedDescription)")
        }
    }
    
    private func saveData() {
        CoreDataManager.shared.saveContext()
        viewController?.reloadCollectionView()
    }
    
    func numberOfItems() -> Int {
        return 2 + tempChildren.count
    }
    
    func configureCell(at indexPath: IndexPath, for collectionView: UICollectionView) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
            cell.person = person
            cell.onSave = { [weak self, weak cell] in
                guard let self = self, let cell = cell else { return }
                self.updatePersonData(from: cell)
            }
            cell.onAddChild = { [weak self] in
                self?.addChild()
            }
            return cell
        } else if indexPath.item <= tempChildren.count {
            let childIndex = indexPath.item - 1
            let child = tempChildren[childIndex]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildCell", for: indexPath) as! ChildCell
            cell.child = .init(model: child)
            cell.onDelete = { [weak self] in
                self?.deleteChild(at: childIndex)
            }
            cell.onSave = { [weak self, weak cell] in
                guard let self = self, let cell = cell else { return }
                self.updateChildData(from: cell, at: childIndex)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClearButtonCell", for: indexPath) as! ClearButtonCell
            cell.onClearTapped = { [weak self] in
                self?.deletePerson()
            }
            return cell
        }
    }
}
