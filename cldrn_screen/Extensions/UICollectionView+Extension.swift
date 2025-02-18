import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
            register(T.self, forCellWithReuseIdentifier: String(describing: name))
        }
}
