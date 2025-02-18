import UIKit

class AddChildCell: UICollectionViewCell {
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Добавить ребенка", for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Дети (макс. 5)"
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    var onAdd: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(addButton)
        
        addButton.addAction(UIAction { [weak self] _ in
            self?.onAdd?()
        }, for: .primaryActionTriggered)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 160),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: addButton.leadingAnchor, constant: -8)
        ])
    }
}

