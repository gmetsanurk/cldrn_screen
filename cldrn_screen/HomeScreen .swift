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
            cell.onSave = { [weak self, weak cell] in
                guard let self = self, let cell = cell else { return }
                self.updatePersonData(from: cell)
                self.savePerson()
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
            cell.onSave = { [weak self, weak cell] in
                guard let self = self, let cell = cell else { return }
                self.updateChildData(from: cell, at: childIndex)
                self.saveChildData(child: child)
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

extension HomeScreen: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let personCell = cell as? PersonCell {
            personCell.nameTextField.text = person?.name
            personCell.ageTextField.text = person?.age
        } else if let childCell = cell as? ChildCell {
            let childIndex = indexPath.item - 1
            let child = tempChildren[childIndex]
            childCell.nameTextField.text = child.name
            childCell.ageTextField.text = child.age
        }
    }
}

//MARK: Transfer it to HomePresenter
extension HomeScreen {
    
    private func updatePersonData(from cell: PersonCell) {
        if person == nil {
            let context = CoreDataManager.shared.context
            person = CoreDataPerson(context: context)
        }
        
        person?.name = cell.nameTextField.text ?? ""
        person?.age = cell.ageTextField.text ?? ""
    }

    private func updateChildData(from cell: ChildCell, at index: Int) {
        tempChildren[index].name = cell.nameTextField.text ?? "Без имени"
        tempChildren[index].age = cell.ageTextField.text ?? "0"
    }
    
    private func loadDataFromCoreData() {
        let context = CoreDataManager.shared.context
        let personRequest: NSFetchRequest<CoreDataPerson> = CoreDataPerson.fetchRequest() as! NSFetchRequest<CoreDataPerson>
        
        do {
            let fetchedPersons = try context.fetch(personRequest)
            
            if let firstPerson = fetchedPersons.first {
                self.person = firstPerson
                self.tempChildren = firstPerson.children.allObjects as? [CoreDataChild] ?? []
            } else {
                self.person = nil
                self.tempChildren = []
            }
            
            collectionView.reloadData()
        } catch {
            print("Ошибка загрузки данных: \(error)")
        }
    }


    private func addChildToPerson() {
        if let personCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? PersonCell {
            updatePersonData(from: personCell)
            savePerson()
        }

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

