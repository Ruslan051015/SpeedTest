import Foundation
import UIKit

// Перечисление для хранения выбранной темы
enum AppTheme: Int {
  case light, dark, unspecified
  
  var userInterfaceStyle: UIUserInterfaceStyle {
    switch self {
    case .dark: return .dark
    case .light: return .light
    case .unspecified: return .unspecified
    }
  }
  
  var themeName: String {
    switch self {
    case .dark: return "Dark"
    case .light: return "Light"
    case .unspecified: return "System"
    }
  }
}

// Протоколо для общения с классом SpeedTestViewController
protocol SettingsViewControllerDelegate: AnyObject {
  var urlString: String { get set }
  func uploadSwitchToggled(to condition: Bool)
  func downloadSwitchToggled(to condition: Bool)
}

final class SettingsViewController: UIViewController {
  // MARK: - Properties:
  //Объявление делегата и указанием его типа
  weak var delegate: SettingsViewControllerDelegate?
  
  // MARK: - Private Properties:
  // Объявление переменных хранящих элементы интрейфеса а также значения свойств
  private var urlString = URLStorage.shared.url {
    didSet {
      URLStorage.shared.url = urlString
      delegate?.urlString = urlString
    }
  }
  private let interfaceStyleNames = ["Dark", "Light", "System"]
  private var selectedCellIndexPath: IndexPath?
  private var currentTheme = ThemeStorage.shared.theme
  
  private lazy var themesTabel: UITableView = {
    let table = UITableView()
    table.backgroundColor = .clear
    table.separatorStyle = .singleLine
    table.allowsMultipleSelection = false
    table.delegate = self
    table.dataSource = self
    table.isScrollEnabled = false
    table.register(CustomCellTableViewCell.self, forCellReuseIdentifier: CustomCellTableViewCell.reuseID)
    
    return table
  }()
  
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.text = "URL address"
    label.font = .systemFont(ofSize: 18, weight: .bold)
    label.textColor = .customBlack
    
    return label
  }()
  
  private lazy var addressTextField: CustomUITextField = {
    let textField = CustomUITextField(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41), placeholder: "Enter URL")
    textField.delegate = self
    textField.text = urlString
    return textField
  }()
  
  private lazy var uploadLabel: UILabel = {
    let label = UILabel()
    label.text = "Measure upload speed"
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.textColor = .customBlack
    
    return label
  }()
  
  private lazy var downloadLabel: UILabel = {
    let label = UILabel()
    label.text = "Measure download speed"
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.textColor = .customBlack
    
    return label
  }()
  
  private lazy var uploadSwitch: UISwitch = {
    let mySwitch = UISwitch()
    mySwitch.isOn = SwitchConditionsStorage.shared.uploadSwitchCondition
    mySwitch.addTarget(self, action: #selector(uploadSwitchToggled), for: .valueChanged)
    
    return mySwitch
  }()
  
  private lazy var downloadSwitch: UISwitch = {
    let mySwitch = UISwitch()
    mySwitch.isOn = SwitchConditionsStorage.shared.downloadSwitchCondition
    mySwitch.addTarget(self, action: #selector(downloadSwitchToggled), for: .valueChanged)
    
    return mySwitch
  }()
  
  // MARK: - Private Methods:
  // Настройка расположения элементов интерфейса
  private func setupLayout() {
    [
      themesTabel,
      addressLabel,
      addressTextField,
      uploadLabel,
      downloadLabel,
      uploadSwitch,
      downloadSwitch
    ].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    setupLayout()
    NSLayoutConstraint.activate([
      themesTabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
      themesTabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
      themesTabel.heightAnchor.constraint(equalToConstant: 150),
      themesTabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      
      addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      addressLabel.topAnchor.constraint(equalTo: themesTabel.bottomAnchor, constant: 20),
      addressLabel.widthAnchor.constraint(equalToConstant: 150),
      addressLabel.heightAnchor.constraint(equalToConstant: 22),
      
      addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      addressTextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
      addressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
      addressTextField.heightAnchor.constraint(equalToConstant: 30),
      
      uploadLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      uploadLabel.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 30),
      uploadLabel.widthAnchor.constraint(equalToConstant: 200),
      uploadLabel.heightAnchor.constraint(equalToConstant: 20),
      
      downloadLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      downloadLabel.topAnchor.constraint(equalTo: uploadLabel.bottomAnchor, constant: 20),
      downloadLabel.widthAnchor.constraint(equalToConstant: 200),
      downloadLabel.heightAnchor.constraint(equalToConstant: 20),
      
      uploadSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
      uploadSwitch.centerYAnchor.constraint(equalTo: uploadLabel.centerYAnchor),
      
      downloadSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
      downloadSwitch.centerYAnchor.constraint(equalTo: downloadLabel.centerYAnchor),
    ])
  }
  
  // Метод для применения выбранной темы
  private func applyTheme(_ theme: UIUserInterfaceStyle) {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      windowScene.windows.forEach { window in
        window.overrideUserInterfaceStyle = theme
      }
    }
  }
}
// MARK: - LifeCycle:
// Жизненный цикл объекта, настройка цвета и вызов методов настройки элементов
extension SettingsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .background
    setupConstraints()
  }
}

// MARK: - Objc-C Methods:
extension SettingsViewController {
  @objc private func uploadSwitchToggled(toggle: UISwitch) {
    SwitchConditionsStorage.shared.uploadSwitchCondition = toggle.isOn
    delegate?.uploadSwitchToggled(to: toggle.isOn)
  }
  
  @objc private func downloadSwitchToggled(toggle: UISwitch) {
    SwitchConditionsStorage.shared.downloadSwitchCondition = toggle.isOn
    delegate?.downloadSwitchToggled(to: toggle.isOn)
  }
}

// MARK: - UITableViewDataSource
// Реализация требуемых методов делегата и dataSource для таблицы, а также методов
//для отработки нажатия на ячейки таблицы и настройка хэдера таблицы
extension SettingsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    interfaceStyleNames.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let themeName = interfaceStyleNames[indexPath.row]
    let isSelected = currentTheme.themeName == interfaceStyleNames[indexPath.row] ? false : true
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCellTableViewCell.reuseID, for: indexPath) as? CustomCellTableViewCell else {
      return UITableViewCell()
    }
    cell.cofigureCell(themeName, isSelected: isSelected)
    
    return cell
  }
  
  
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == interfaceStyleNames.count - 1 {
      cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    } else {
      cell.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    30
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if selectedCellIndexPath == indexPath {
      selectedCellIndexPath = nil
    } else {
      selectedCellIndexPath = indexPath
    }
    guard let cell = tableView.cellForRow(at: indexPath) as? CustomCellTableViewCell else {
      return
    }
    tableView.deselectRow(at: indexPath, animated: true)
    let isSelected = selectedCellIndexPath == indexPath ? true : false
    cell.setupCheckmark(isHidden: isSelected)
    if interfaceStyleNames[indexPath.row] == "Light" {
      currentTheme = .light
      ThemeStorage.shared.theme = .light
      applyTheme(.light)
    } else if interfaceStyleNames[indexPath.row] == "Dark" {
      currentTheme = .dark
      ThemeStorage.shared.theme = .dark
      applyTheme(.dark)
    } else if interfaceStyleNames[indexPath.row] == "System" {
      currentTheme = .unspecified
      ThemeStorage.shared.theme = .unspecified
      applyTheme(.unspecified)
    }
    
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
    let label = UILabel(frame: CGRect(x: 12, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
    label.text = "Themes"
    label.font = .systemFont(ofSize: 18, weight: .bold)
    label.textColor = .customBlack
    headerView.addSubview(label)
    headerView.tintColor = .clear
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    30
  }
}

// MARK: - UITextFieldDelegate:
// Реализцаия методов делегата текстового поля для реагирования на изменения в текстовом поле
extension SettingsViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let url = textField.text else {
      return
    }
    urlString = url
  }
}
