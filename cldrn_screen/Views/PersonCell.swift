import UIKit

class PersonCell: UICollectionViewCell {
    let nameTextField = CustomTextField()
    let ageTextField = CustomTextField()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text =  NSLocalizedString("person_cell.child_max", comment: "Maximum child label")
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = AppColors.childCellTextColor
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("person_cell.add_child", comment: "Add child button"), for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        return button
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .leading
        return stack
    }()
    
    var person: Person? {
        didSet {
            nameTextField.text = person?.name
            ageTextField.text = person?.age
        }
    }
    
    var onSave: (() -> Void)?
    var onAddChild: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupTextFieldsUI()
        setupChildUI()
        
        addButton.addAction(UIAction { [weak self] _ in
            self?.onAddChildTapped()
        }, for: .primaryActionTriggered)
        
        contentView.addSubview(stackView)
        setupConstraints()
    }
    
    private func setupTextFieldsUI() {
        nameTextField.setupNameTextField(placeholder: NSLocalizedString("person_cell.name_placeholder", comment: "Name placeholder"))
        ageTextField.setupNameTextField(placeholder: NSLocalizedString("person_cell.age_placeholder", comment: "Age placeholder"), isNumeric: true)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(ageTextField)
    }
    
    private func setupChildUI() {
        let childStack = UIStackView(arrangedSubviews: [titleLabel, addButton])
        childStack.axis = .horizontal
        childStack.spacing = 8
        childStack.alignment = .center
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        stackView.addArrangedSubview(childStack)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppGeometry.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            nameTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: AppGeometry.personCellTextFieldsWidth),
            nameTextField.heightAnchor.constraint(equalToConstant: AppGeometry.personCellTextFieldsHeight),
            
            ageTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: AppGeometry.personCellTextFieldsWidth),
            ageTextField.heightAnchor.constraint(equalToConstant: AppGeometry.personCellTextFieldsHeight),
            
            addButton.widthAnchor.constraint(equalToConstant: 180),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func onAddChildTapped() {
        print("AddChild pressed inside PersonCell")
        onAddChild?()
    }
}
