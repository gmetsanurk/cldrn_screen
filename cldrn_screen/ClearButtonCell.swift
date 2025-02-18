import UIKit

class ClearButtonCell: UICollectionViewCell {
    
    var onClearTapped: (() -> Void)?
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Очистить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addAction(UIAction { [weak self] _ in
            self?.onClearTapped?()
        }, for: .primaryActionTriggered)
        
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            clearButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            clearButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            clearButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            clearButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

