import UIKit

class PersonCell: UICollectionViewCell {
    
    let nameTextField = UITextField()
    let ageTextField = UITextField()
    
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
        setupNameTextField()
        setupAgetextField()
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(ageTextField)
    }
    
    func setupNameTextField() {
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Имя",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.personCellTextAligmentColor]
        )
        nameTextField.textColor = AppColors.personCellTextColor
        nameTextField.layer.borderColor = AppColors.borderColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = AppGeometry.cornerRadius
        nameTextField.clipsToBounds = true
    }
    
    func setupAgetextField() {
        ageTextField.attributedPlaceholder = NSAttributedString(
            string: "Возраст",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.personCellTextAligmentColor]
        )
        ageTextField.textColor = AppColors.personCellTextColor
        ageTextField.layer.borderColor = AppColors.borderColor
        ageTextField.layer.borderWidth = 1.0
        ageTextField.layer.cornerRadius = AppGeometry.cornerRadius
        ageTextField.clipsToBounds = true
        ageTextField.keyboardType = .numberPad
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

