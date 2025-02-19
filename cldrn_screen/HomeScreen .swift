import UIKit

class HomeScreen: UIViewController {
    
    var viewModel: HomeViewModel!
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(viewController: self)
        setupCollectionView()
        view.backgroundColor = UIColor.white
        viewModel.loadData()
        
        viewModel.onShowAlert = { [weak self] title, message, confirmTitle, cancelTitle in
            self?.showAlert(title: title, message: message, confirmTitle: confirmTitle, cancelTitle: cancelTitle)
        }
        viewModel.onShowStopAlert = { [weak self] title, message, cancelTitle in
            self?.showStopAlert(title: title, message: message, cancelTitle: cancelTitle)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        registerCells()
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func registerCells() {
        collectionView.register(cellWithClass: PersonCell.self)
        collectionView.register(cellWithClass: ChildCell.self)
        collectionView.register(cellWithClass: ClearButtonCell.self)
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension HomeScreen: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.configureCell(at: indexPath, for: collectionView)
    }
    
}

extension HomeScreen: UICollectionViewDelegate {}

extension HomeScreen {
    
    func returnPersonCell() -> UICollectionViewCell? {
        return collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? PersonCell
    }
    
    private func showAlert(title: String, message: String, confirmTitle: String, cancelTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmTitle, style: .destructive) { [weak self] _ in
            self?.viewModel.deletePerson()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func showStopAlert(title: String, message: String, cancelTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)

        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
