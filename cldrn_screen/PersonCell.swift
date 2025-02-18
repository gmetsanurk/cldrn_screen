import UIKit

class PersonCell: UICollectionViewCell {
    
    let nameTextField = CustomTextField()
    let ageTextField = CustomTextField()
    
    private let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fillProportionally
            stack.spacing = 10
            return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupTextFieldsUI()
        contentView.addSubview(stackView)
        setupConstraints()
    }
    
    private func setupTextFieldsUI() {
        nameTextField.setupNameTextField(placeholder: "Имя")
        ageTextField.setupNameTextField(placeholder: "Возраст", isNumeric: true)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(ageTextField)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            nameTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
            nameTextField.heightAnchor.constraint(equalToConstant: 64),
            
            ageTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
            ageTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
}

