import UIKit

class ChildCell: UICollectionViewCell {
    let nameTextField = UITextField()
    let ageTextField = UITextField()
    var deleteButton = UIButton(type: .system)
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    var onDelete: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        setupTextFieldsUI()
        setupDeleteButton()
        contentView.addSubview(stackView)
        setupConstraints()
    }
    
    private func setupTextFieldsUI() {
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Имя",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.childCellTextAligmentColor]
        )
        nameTextField.textColor = AppColors.childCellTextColor
        ageTextField.attributedPlaceholder = NSAttributedString(
            string: "Возраст",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.childCellTextAligmentColor]
        )
        ageTextField.textColor = AppColors.childCellTextColor
        ageTextField.keyboardType = .numberPad
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(ageTextField)
    }
    
    private func setupDeleteButton() {
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.addAction(UIAction { [weak self] _ in
            self?.deleteTapped()
        }, for: .touchUpInside)
        stackView.addArrangedSubview(deleteButton)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func deleteTapped() {
        onDelete?()
    }
}
