import UIKit

class HomeScreen: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private var person = Person(name: "", age: "", children: [])
    
    private let maxChildrenCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.backgroundColor = UIColor.white
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
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
                return person.children.count + (person.children.count < maxChildrenCount ? 1 : 0)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
            return cell
        } else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddChildCell", for: indexPath) as! AddChildCell
                cell.onAdd = {
                    let newChild = Child(name: "", age: "")
                    self.person.children.append(newChild)
                    
                    let newIndexPath = IndexPath(item: self.person.children.count, section: 1)
                    self.collectionView.insertItems(at: [newIndexPath])
                }
                return cell
            } else {
                let childIndex = indexPath.item - 1
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildCell", for: indexPath) as! ChildCell
                cell.onDelete = {
                    self.person.children.remove(at: childIndex)
                    self.collectionView.deleteItems(at: [indexPath])
                }
                return cell
            }
        }
    }

}
