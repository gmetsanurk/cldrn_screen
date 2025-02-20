import UIKit

class ClearButtonCell: UICollectionViewCell {
    
    var onClearTapped: (() -> Void)?
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("clear_button_cell.clear_button", comment: "Clear Button"), for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
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
            clearButton.widthAnchor.constraint(equalToConstant: 180),
            clearButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

