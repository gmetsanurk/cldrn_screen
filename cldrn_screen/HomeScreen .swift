import UIKit

class HomeScreen: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private var person = Person(name: "", age: "", children: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    
}

extension HomeScreen {
    private func setupCollectonView() {
        
    }
}
