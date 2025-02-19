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
        collectionView.register(cellWithClass: AddChildCell.self)
        collectionView.register(cellWithClass: ClearButtonCell.self)
    }
}

extension HomeScreen: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let childrenCount = tempChildren.count
            let addButtonCount = childrenCount < maxChildrenCount ? 1 : 0
            return childrenCount + addButtonCount + 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
            return cell
        } else {
            let childrenCount = tempChildren.count
            let addButtonIndex = childrenCount < maxChildrenCount ? 0 : -1
            let clearButtonIndex = childrenCount + (addButtonIndex == 0 ? 1 : 0)
            
            if indexPath.item == addButtonIndex {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddChildCell", for: indexPath) as! AddChildCell
                cell.onAdd = { [weak self] in
                    self?.addChildToPerson()
                }
                return cell
            } else if indexPath.item == clearButtonIndex {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClearButtonCell", for: indexPath) as! ClearButtonCell
                cell.onClearTapped = {
                    self.deletePerson()
                }
                return cell
            } else {
                let childIndex = indexPath.item - (addButtonIndex == 0 ? 1 : 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildCell", for: indexPath) as! ChildCell
                let child = tempChildren[childIndex]
                cell.child = child
                cell.onDelete = {
                    self.deleteChild(at: childIndex)
                }
                cell.onSave = {
                    self.saveChildData(child: child)
                }
                return cell
            }
        }
    }
}

extension HomeScreen {
    
    private func addChildToPerson() {
        let context = CoreDataManager.shared.context
        let newChild = CoreDataChild(context: context)
        newChild.name = "New Child"
        newChild.age = "Age"
        
        tempChildren.append(newChild)
        collectionView.reloadData()
    }
    
    private func saveChildData(child: CoreDataChild) {

        if child.name?.isEmpty == true || child.age?.isEmpty == true {
            print("Недостаточно данных для сохранения")
            return
        }
        
        CoreDataManager.shared.saveContext()
        collectionView.reloadData()
    }
    
    private func deleteChild(at index: Int) {
        tempChildren.remove(at: index)
        collectionView.reloadData()
    }
    
    private func deletePerson() {
        guard let person = person else { return }
        
        CoreDataManager.shared.context.delete(person)
        CoreDataManager.shared.saveContext()
        collectionView.reloadData()
    }
}

