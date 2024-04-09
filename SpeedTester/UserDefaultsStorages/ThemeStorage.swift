import Foundation

final class ThemeStorage {
  static let shared = ThemeStorage()
  private let key = "Theme"
  var theme: AppTheme {
    get {
      let savedTheme = UserDefaults.standard.integer(forKey: key)
      return AppTheme(rawValue: savedTheme) ?? .light
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: key)
    }
  }
}
