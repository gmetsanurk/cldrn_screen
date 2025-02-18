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
        nameTextField.placeholder = "Имя"
        ageTextField.placeholder = "Возраст"
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
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func deleteTapped() {
        onDelete?()
    }
}
