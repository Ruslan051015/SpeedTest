import Foundation
import UIKit

// Класс для кастомизации поведения текстового поля
final class CustomUITextField: UITextField {
  // MARK: - Properties:
  let insets: UIEdgeInsets
  // MARK: - Initializers:
  init(insets: UIEdgeInsets, placeholder text: String) {
    self.insets = insets
    super.init(frame: .zero)
    
    attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    clearButtonMode = .whileEditing
    
    textColor = .black
    font = .systemFont(ofSize: 17, weight: .regular)
    layer.masksToBounds = true
    layer.cornerRadius = 8
    backgroundColor = .lightGray
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - Insets:
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: insets)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: insets)
  }
  
  override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
    let originalRect = super.clearButtonRect(forBounds: bounds)
    return originalRect.offsetBy(dx: -5, dy: 0)
  }
}
