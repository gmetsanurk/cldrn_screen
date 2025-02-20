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
    
    func presentAlertControllerForClearAction() {
        let controllerTitle = NSLocalizedString("home_screen.alert_title", comment: "Home screean alert controller title")
        let controllerMessage = NSLocalizedString("home_screen.alert_message", comment: "Home screen alert controller message")
        let deleteButtonTitle = NSLocalizedString("home_screen.alert_clear_button", comment: "Home screen alert controller clear button")
        let cancelButtonTitle = NSLocalizedString("home_screen.alert_cancel_button", comment: "Home screen alert controller cancel button")
        
        let alertController = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: deleteButtonTitle , style: .destructive) { [weak self] _ in
            
            Task {
                do {
                    self?.viewModel.deletePerson()
                    self?.collectionView.reloadData()
                    print("Task deleted successfully.")
                }
            }
        }
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func presentStopAlertController() {
        let controllerTitle = NSLocalizedString("home_screen.stop_alert_title", comment: "Home screen stop alert controller title")
        let controllerMessage = NSLocalizedString("home_screen.stop_alert_message", comment: "Home screen stop alert controller message")
        let oKMessage = NSLocalizedString("home_screen.stop_alert_ok", comment: "Home screen stop alert controller message OK")
        
        let alertController = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: oKMessage, style: .cancel)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
