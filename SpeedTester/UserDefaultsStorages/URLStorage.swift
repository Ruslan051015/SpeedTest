import Foundation
import UIKit

final class URLStorage {
  static let shared = URLStorage()
  private let urlKey = "url"
  var url: String {
    get {
      UserDefaults.standard.string(forKey: urlKey) ?? "https://www.apple.com"
    }
    set {
      UserDefaults.standard.set(newValue, forKey: urlKey)
    }
  }
}
