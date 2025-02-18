import UIKit

class ChildCell: UICollectionViewCell {
    let nameTextField = CustomTextField()
    let ageTextField = CustomTextField()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .leading
        return stack
    }()
    
    var onDelete: (() -> Void)?
    var deleteButton = UIButton(type: .system)
    
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
        contentView.addSubview(deleteButton)
        setupConstraints()
    }
    
    private func setupTextFieldsUI() {
        nameTextField.setupNameTextField(placeholder: " Имя")
        ageTextField.setupNameTextField(placeholder: " Возраст", isNumeric: true)
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(ageTextField)
    }
    
    private func setupDeleteButton() {
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.addAction(UIAction { [weak self] _ in
            self?.onDelete?()
        }, for: .primaryActionTriggered)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            deleteButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -90),
            
            nameTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            nameTextField.heightAnchor.constraint(equalToConstant: 64),
            
            ageTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            ageTextField.heightAnchor.constraint(equalToConstant: 64),
        ])
    }
}

