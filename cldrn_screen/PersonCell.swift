import UIKit

class PersonCell: UICollectionViewCell {
    
    let nameTextField = UITextField()
    let ageTextField = UITextField()
    
    private let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 8
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
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Имя",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.personCellTextAligmentColor]
        )
        nameTextField.textColor = AppColors.personCellTextColor
        ageTextField.attributedPlaceholder = NSAttributedString(
            string: "Возраст",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.personCellTextAligmentColor]
        )
        ageTextField.textColor = AppColors.personCellTextColor
        ageTextField.keyboardType = .numberPad
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(ageTextField)
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
}
