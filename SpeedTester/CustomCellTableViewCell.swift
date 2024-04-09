import UIKit

// Класс кастомной ячейки для выбора темы интерйфеса
class CustomCellTableViewCell: UITableViewCell {
  // MARK: - Properties:
  static let reuseID = "ThemeCell"
  
// MARK: - Private Properties:
  private lazy var themeNameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .customBlack
    label.textAlignment = .left
    
    return label
  }()
  
  private lazy var checkmarkImageView: UIImageView = {
    let image = UIImage(systemName: "checkmark")
    let checkmark = UIImageView(image: image)
    checkmark.tintColor = .customBlack
    checkmark.contentMode = .scaleAspectFill
    
    return checkmark
  }()
  
  // MARK: - Methods:
  func cofigureCell(_ name: String, isSelected: Bool) {
    themeNameLabel.text = name
    checkmarkImageView.isHidden = isSelected
  }
  
  func setupCheckmark(isHidden: Bool) {
    checkmarkImageView.isHidden = isHidden
  }
  
  // MARK: - Private Mthods:
  private func setupCellUI() {
    [themeNameLabel, checkmarkImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      themeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      themeNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
      checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
      checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
  // MARK: - LifeCycle:
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCellUI()
    self.backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
