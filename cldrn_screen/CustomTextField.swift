import UIKit

class CustomTextField: UITextField {
    
    func setupNameTextField(placeholder: String, isNumeric: Bool = false) {
        if isNumeric {
            self.attributedPlaceholder = NSAttributedString(
                string: "Возраст",
                attributes: [NSAttributedString.Key.foregroundColor: AppColors.personCellTextAligmentColor]
            )
            self.keyboardType = .numberPad
        } else {
            self.attributedPlaceholder = NSAttributedString(
                string: "Имя",
                attributes: [NSAttributedString.Key.foregroundColor: AppColors.personCellTextAligmentColor]
            )
        }
        self.textColor = AppColors.personCellTextColor
        self.layer.borderColor = AppColors.borderColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = AppGeometry.cornerRadius
        self.clipsToBounds = true
    }
    
    private func setupNameTextField() {
        
    }
}
