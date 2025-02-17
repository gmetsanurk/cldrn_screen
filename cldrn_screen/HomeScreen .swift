import UIKit

class HomeScreen: UIViewController, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView!
    
    private var person = Person(name: "", age: "", children: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectonView()
        view.backgroundColor = UIColor.white
    }
    
    private func setupCollectonView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerCellsToTheCollectionView()
        view.addSubview(collectionView)
        setupCollectionViewConstraints()
    }
    
    private func registerCellsToTheCollectionView() {
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: "PersonCell")
        collectionView.register(ChildCell.self, forCellWithReuseIdentifier: "ChildCell")
        collectionView.register(AddChildCell.self, forCellWithReuseIdentifier: "AddChildCell")
    }
}

extension HomeScreen: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : person.children.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
            return cell
        } else {
            if indexPath.item < person.children.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildCell", for: indexPath) as! ChildCell
                cell.onDelete = {
                    self.person.children.remove(at: indexPath.item)
                    self.collectionView.reloadData()
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddChildCell", for: indexPath) as! AddChildCell
                cell.onAdd = {
                    self.person.children.append(Child(name: "", age: ""))
                    self.collectionView.reloadData()
                }
                return cell
            }
        }
    }
}

extension HomeScreen {
    private func setupCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
