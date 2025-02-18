import UIKit

class AddChildCell: UICollectionViewCell {
    let addButton = UIButton(type: .system)
    
    var onAdd: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupAddButton()
        addSubview(addButton)
        setupConstraints()
    }
    
    private func setupAddButton() {
        addButton.setTitle("Добавить ребенка", for: .normal)
        addButton.addAction(UIAction { [weak self] _ in
            self?.addTapped()
        }, for: .touchUpInside)
    }
    
    private func setupConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func addTapped() {
        onAdd?()
    }
}
