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
    var onSave: (() -> Void)?
    
    var deleteButton = UIButton(type: .system)
    var saveButton = UIButton(type: .system)
    
    var child: Child? {
        didSet {
            nameTextField.text = child?.name
            ageTextField.text = child?.age
            //checkIfSaveButtonShouldBeVisible()
        }
    }
    
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
        setupSaveButton()
        
        contentView.addSubview(stackView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(saveButton)
        
        setupConstraints()
    }
    
    private func setupTextFieldsUI() {
        nameTextField.setupNameTextField(placeholder: NSLocalizedString("child_cell.name_placeholder", comment: "Name placeholder"))
        ageTextField.setupNameTextField(placeholder: NSLocalizedString("child_cell.age_placeholder", comment: "Age placeholder"), isNumeric: true)
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(ageTextField)
    }
    
    private func setupDeleteButton() {
        deleteButton.setTitle(NSLocalizedString("child_cell.delete_button", comment: "ChildCell delete button"), for: .normal)
        deleteButton.addAction(UIAction { [weak self] _ in
            self?.onDelete?()
        }, for: .primaryActionTriggered)
    }
    
    private func setupSaveButton() {
        saveButton.setTitle(NSLocalizedString("child_cell.save_button", comment: "ChildCell dave button"), for: .normal)
        saveButton.addAction(UIAction { [weak self] _ in
            self?.onSave?()
            //self?.isHidden = true
        }, for: .primaryActionTriggered)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppGeometry.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            deleteButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: AppGeometry.childCellButtonsLeadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: AppGeometry.childCellButtonsTrailingAnchor),
            
            saveButton.centerYAnchor.constraint(equalTo: ageTextField.centerYAnchor),
            saveButton.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: AppGeometry.childCellButtonsLeadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: AppGeometry.childCellButtonsTrailingAnchor),
            
            nameTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: AppGeometry.childCellTextFieldsWidth),
            nameTextField.heightAnchor.constraint(equalToConstant: AppGeometry.childCellTextFieldsHeight),
            
            ageTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: AppGeometry.childCellTextFieldsWidth),
            ageTextField.heightAnchor.constraint(equalToConstant: AppGeometry.childCellTextFieldsHeight),
        ])
    }
    
    private func checkIfSaveButtonShouldBeVisible() {
        let isNameValid = !(nameTextField.text?.isEmpty ?? true)
        let isAgeValid = !(ageTextField.text?.isEmpty ?? true)
        saveButton.isHidden = !(isNameValid && isAgeValid)
    }
}

