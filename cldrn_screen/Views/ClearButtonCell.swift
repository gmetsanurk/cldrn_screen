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
            clearButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppGeometry.topAnchor),
            clearButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppGeometry.clearButtonLeadingAndTrailingAnchor),
            clearButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: AppGeometry.clearButtonLeadingAndTrailingAnchor),
            clearButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: AppGeometry.bottomAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: AppGeometry.clearButtonWidth),
            clearButton.heightAnchor.constraint(equalToConstant: AppGeometry.clearButtonHeight)
        ])
    }
}

