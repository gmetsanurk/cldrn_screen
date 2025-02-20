import UIKit
import CoreData

class HomeScreen: UIViewController {
    
    private var collectionView: UICollectionView!
    private var person: CoreDataPerson?
    private var tempChildren: [CoreDataChild] = []
    
    private let maxChildrenCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.backgroundColor = UIColor.white
        loadDataFromCoreData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        registerCellsToTheCollectionView()
        view.addSubview(collectionView)
        collectionView.fillToSuperview()
    }
    
    private func registerCellsToTheCollectionView() {
        collectionView.register(cellWithClass: PersonCell.self)
        collectionView.register(cellWithClass: ChildCell.self)
        collectionView.register(cellWithClass: ClearButtonCell.self)
    }
}

extension HomeScreen: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + tempChildren.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
            cell.person = person
            cell.onSave = { [weak self] in
                self?.savePerson()
            }
            cell.onAddChild = { [weak self] in
                self?.addChildToPerson()
            }
            return cell
        } else if indexPath.item <= tempChildren.count {
            let childIndex = indexPath.item - 1
            let child = tempChildren[childIndex]

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildCell", for: indexPath) as! ChildCell
            cell.child = child
            cell.onDelete = { [weak self] in
                self?.deleteChild(at: childIndex)
            }
            cell.onSave = { [weak self] in
                self?.saveChildData(child: child)
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

//MARK: Transfer it to HomePresenter
extension HomeScreen {
    
    private func loadDataFromCoreData() {
        
        let context = CoreDataManager.shared.context
        let personRequest: NSFetchRequest<CoreDataPerson> = CoreDataPerson.fetchRequest() as! NSFetchRequest<CoreDataPerson>
        
        do {
            let fetchedPersons = try context.fetch(personRequest)
            if let firstPerson = fetchedPersons.first {
                self.person = firstPerson
                self.tempChildren = firstPerson.children.allObjects as? [CoreDataChild] ?? []
                collectionView.reloadData()
            }
        } catch {
            print("Error loading person data: \(error)")
        }
    }

    private func addChildToPerson() {
        //guard let person = person else { return }

        let context = CoreDataManager.shared.context
        let newChild = CoreDataChild(context: context)
        newChild.name = "Новое имя"
        newChild.age = "0"
        newChild.parent = person

        tempChildren.append(newChild)
        CoreDataManager.shared.saveContext()
        collectionView.reloadData()
    }

    
    private func saveChildData(child: CoreDataChild) {
            CoreDataManager.shared.saveContext()
            collectionView.reloadData()
        }
    
    private func savePerson() {
        guard let person = person else { return }
        
        person.name = person.name ?? "SampleName"
        person.age = person.age ?? "30"
        
        CoreDataManager.shared.saveContext()
        collectionView.reloadData()
    }
    
    
    private func deleteChild(at index: Int) {
        let context = CoreDataManager.shared.context
        let childToDelete = tempChildren[index]
        
        context.delete(childToDelete)
        tempChildren.remove(at: index)
        
        CoreDataManager.shared.saveContext()
        collectionView.reloadData()
    }
    
    private func deletePerson() {
        guard let person = person else { return }
        
        let context = CoreDataManager.shared.context
        
        for child in tempChildren {
            context.delete(child)
        }
        
        context.delete(person)
        
        CoreDataManager.shared.saveContext()
        collectionView.reloadData()
    }
}

