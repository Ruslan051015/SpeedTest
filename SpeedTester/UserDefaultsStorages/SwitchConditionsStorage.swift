import Foundation
import UIKit

final class SwitchConditionsStorage {
  static let shared = SwitchConditionsStorage()
  private let uploadKey = "uploadSwitch"
  private let downloadKey = "downloadKey"
  
  var uploadSwitchCondition: Bool {
    get {
      UserDefaults.standard.bool(forKey: uploadKey)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: uploadKey)
    }
  }
  
  var downloadSwitchCondition: Bool {
    get {
      UserDefaults.standard.bool(forKey: downloadKey)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: downloadKey)
    }
  }
}
