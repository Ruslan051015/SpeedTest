import UIKit

final class SpeedTestViewController: UIViewController {
  // MARK: - Properties:
  var urlString = URLStorage.shared.url
  // MARK: - Private Properties:
  // Обхявляем переменные хранящие элементы интерфейса
  private let speedTestService = NetworkServiceWithAlamofire.shared
  private lazy var currentSpeedLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 2
    label.textColor = .customBlack
    label.text = "Current speed,\nMbps"
    label.isHidden = true
    
    return label
  }()
  
  private lazy var measuredSpeedLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 2
    label.textColor = .customBlack
    label.text = "Average speed,\nMbps"
    label.isHidden = true
    
    return label
  }()
  
  private lazy var uploadSpeedLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 2
    label.textColor = .customBlack
    label.text = "Upload speed,\nMbps"
    label.isHidden = !SwitchConditionsStorage.shared.uploadSwitchCondition
    
    return label
  }()
  
  private lazy var downloadSpeedLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 2
    label.textColor = .customBlack
    label.text = "Download speed,\nMbps"
    label.isHidden = !SwitchConditionsStorage.shared.downloadSwitchCondition
    
    return label
  }()
  
  private lazy var uploadSpeedValue: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 1
    label.textColor = .customBlack
    label.text = "--"
    label.isHidden = !SwitchConditionsStorage.shared.uploadSwitchCondition
    
    return label
  }()
  
  private lazy var downloadSpeedValue: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 1
    label.textColor = .customBlack
    label.text = "--"
    label.isHidden = !SwitchConditionsStorage.shared.downloadSwitchCondition
    
    return label
  }()
  
  private lazy var currentSpeedValue: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 1
    label.textColor = .customBlack
    
    return label
  }()
  
  private lazy var measuredSpeedValue: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 1
    label.textColor = .customBlack
    
    return label
  }()
  
  private var testButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Test", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 34, weight: .bold)
    button.tintColor = .customWhite
    button.backgroundColor = .customBlack
    button.layer.cornerRadius = 100
    button.layer.masksToBounds = true
    button.addTarget(self, action: #selector(testButtonPressed), for: .touchUpInside)
    
    return button
  }()
  
  // MARK: - Private Methods:
  // Выполняем настройку расположения элементов интерфейса
  private func setupLayout() {
    [currentSpeedLabel, measuredSpeedLabel,uploadSpeedLabel, downloadSpeedLabel, currentSpeedValue, measuredSpeedValue, downloadSpeedValue, uploadSpeedValue, testButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    setupLayout()
    NSLayoutConstraint.activate([
      currentSpeedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
      currentSpeedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      currentSpeedLabel.widthAnchor.constraint(equalToConstant: 150),
      currentSpeedLabel.heightAnchor.constraint(equalToConstant: 50),
      
      measuredSpeedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
      measuredSpeedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      measuredSpeedLabel.widthAnchor.constraint(equalToConstant: 150),
      measuredSpeedLabel.heightAnchor.constraint(equalToConstant: 50),
      
      uploadSpeedLabel.leadingAnchor.constraint(equalTo: currentSpeedLabel.leadingAnchor),
      uploadSpeedLabel.topAnchor.constraint(equalTo: currentSpeedLabel.bottomAnchor, constant: 50),
      uploadSpeedLabel.widthAnchor.constraint(equalToConstant: 150),
      uploadSpeedLabel.heightAnchor.constraint(equalToConstant: 50),
      
      downloadSpeedLabel.trailingAnchor.constraint(equalTo: measuredSpeedLabel.trailingAnchor),
      downloadSpeedLabel.topAnchor.constraint(equalTo: measuredSpeedLabel.bottomAnchor, constant: 50),
      downloadSpeedLabel.widthAnchor.constraint(equalToConstant: 150),
      downloadSpeedLabel.heightAnchor.constraint(equalToConstant: 50),
      
      currentSpeedValue.bottomAnchor.constraint(equalTo: currentSpeedLabel.topAnchor, constant: 5),
      currentSpeedValue.leadingAnchor.constraint(equalTo: currentSpeedLabel.leadingAnchor),
      currentSpeedValue.widthAnchor.constraint(equalToConstant: 150),
      currentSpeedValue.heightAnchor.constraint(equalToConstant: 40),
      
      measuredSpeedValue.bottomAnchor.constraint(equalTo: measuredSpeedLabel.topAnchor, constant: 5),
      measuredSpeedValue.trailingAnchor.constraint(equalTo: measuredSpeedLabel.trailingAnchor),
      measuredSpeedValue.heightAnchor.constraint(equalToConstant: 40),
      measuredSpeedValue.widthAnchor.constraint(equalToConstant: 150),
      
      uploadSpeedValue.bottomAnchor.constraint(equalTo: uploadSpeedLabel.topAnchor, constant: 5),
      uploadSpeedValue.leadingAnchor.constraint(equalTo: uploadSpeedLabel.leadingAnchor),
      uploadSpeedValue.widthAnchor.constraint(equalToConstant: 150),
      uploadSpeedValue.heightAnchor.constraint(equalToConstant: 40),
      
      downloadSpeedValue.bottomAnchor.constraint(equalTo: downloadSpeedLabel.topAnchor, constant: 5),
      downloadSpeedValue.trailingAnchor.constraint(equalTo: downloadSpeedLabel.trailingAnchor),
      downloadSpeedValue.heightAnchor.constraint(equalToConstant: 40),
      downloadSpeedValue.widthAnchor.constraint(equalToConstant: 150),
      
      testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      testButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
      testButton.widthAnchor.constraint(equalToConstant: 200),
      testButton.heightAnchor.constraint(equalToConstant: 200)
    ])
  }
  
  // НАстраиваем navBar и добавляем к нему кнопку нстроек
  private func setupNavBar() {
    if navigationController?.navigationBar != nil {
      let rightButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonPressed))
      rightButton.tintColor = .customBlack
      navigationItem.rightBarButtonItem = rightButton
    }
  }
}

// MARK: - LifeCycle:
// Жизненный цикл нашего класса, задаем цвет фона, вызываем методы
extension SpeedTestViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .background
    setupConstraints()
    setupNavBar()
    
  }
}

// MARK: - Obj-C Methods:
//Обработка нажатия кнопки настроек, инициализация контроллера с настройками и его настройка
extension SpeedTestViewController {
  @objc private func settingsButtonPressed() {
    let viewControllerToPresent = SettingsViewController()
    viewControllerToPresent.delegate = self
    viewControllerToPresent.title = "Settings"
    navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationController?.navigationBar.tintColor = .customBlack
    navigationController?.pushViewController(viewControllerToPresent, animated: true)
  }
  
  // Отработка нажатия кнопки тестирования скорости
  @objc private func testButtonPressed() {
    UIBlockingProgressHUD.show()
    [currentSpeedLabel, measuredSpeedLabel].forEach { $0.isHidden = false
    }
    currentSpeedValue.text = ""
    measuredSpeedValue.text = ""
    speedTestService.fetchData(url: urlString) { result in
      switch result {
      case .success(let speed):
        let shortValue = String(format: "%0.1f", speed)
        DispatchQueue.main.async {
          self.currentSpeedValue.text = shortValue
        }
      case .failure(let error):
        let alert = UIAlertController(
          title: "Error",
          message: "\(error.localizedDescription)",
          preferredStyle: .alert
        )
        let action1 = UIAlertAction(title: "Cancel", style: .cancel)
        let action2 = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
          self?.testButtonPressed()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true)
      }
    } completion: { speed in
      let shortValue = String(format: "%0.1f", speed)
      DispatchQueue.main.async {
        self.measuredSpeedValue.text = shortValue
        UIBlockingProgressHUD.hide()
      }
    }
  }
}

// Подписка контроллера на проткол для взаимодействия классов между собой (паттерн делегат)
extension SpeedTestViewController: SettingsViewControllerDelegate {
  func uploadSwitchToggled(to condition: Bool) {
    uploadSpeedLabel.isHidden = !condition
    uploadSpeedValue.isHidden = !condition
  }
  
  func downloadSwitchToggled(to condition: Bool) {
    downloadSpeedLabel.isHidden = !condition
    downloadSpeedValue.isHidden = !condition
  }
}
