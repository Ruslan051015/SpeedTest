import Foundation
import UIKit

final class URLStorage {
  static let shared = URLStorage()
  private let key = "url"
  var url: String {
    get {
      UserDefaults.standard.string(forKey: key) ?? "https://www.apple.com"
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}
