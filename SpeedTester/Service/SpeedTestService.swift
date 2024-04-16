import Foundation
import Alamofire
import UIKit

// Сервис для выполнения запросов в сеть с помощью библиотеки Alamofire
final class NetworkServiceWithAlamofire {
  // MARK: - Properties:
  static let shared = NetworkServiceWithAlamofire(); private init() { }
  
  // MARK: - Private Properties:
  private let uploadURLString = "https://file.io"
  private let downloadURLString = "https://img3.akspic.ru/crops/2/9/8/1/7/171892/171892-sassi_di_matera-kampanya-yuzhnaya_italiya-plato_murge-puteshestvie-7680x4320.jpg"
  
  // MARK: - Methods:
  func measureCurrentandAverageSpeedFor(url: String, instantSpeed: @escaping (Result<Double, Error>) -> Void, completion: @escaping (Double) -> Void) {
    let iterations = 5
    var instantSpeedArray = [Double]()
    let group = DispatchGroup()
    
    DispatchQueue.global().async {
      for _ in 0..<iterations {
        group.enter()
        let startTime = Date()
        AF.request(url)
          .validate()
          .response { response in
            let end = Date()
            let elapsedTime = end.timeIntervalSince(startTime)
            if let data = response.data {
              let fileSize = Double(data.count)
              let speed = (fileSize/elapsedTime) * 8 / 1_000_000
              instantSpeedArray.append(speed)
              instantSpeed(.success(speed))
            } else if let error = response.error {
              instantSpeed(.failure(error))
            }
            group.leave()
          }
        Thread.sleep(forTimeInterval: 0.1)
      }
      group.notify(queue: .main) {
        let averageSpeed = instantSpeedArray.reduce(0,+)/Double(iterations)
        completion(averageSpeed)
      }
    }
  }
  
  func measureCurrentandAverageSpeedForImageUpload(instantSpeed: @escaping (Result<Double, Error>) -> Void, completion: @escaping (Double) -> Void) {
    let image = UIImage(named: "uploadImage")
    guard let imageData = image?.jpegData(compressionQuality: 1.0) else {
      completion(0)
      return
    }
    var instantSpeedArray = [Double]()
    let startTime = Date()
    
    AF.upload(multipartFormData: { multipartFormData in
      multipartFormData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
    }, to: uploadURLString).uploadProgress { progress in
      let uploadedBytes = Double(progress.completedUnitCount)
      let currentTime = Date()
      let elapsedTime = currentTime.timeIntervalSince(startTime)
      let speed = (uploadedBytes / elapsedTime) * 8 / 1_000_000
      instantSpeed(.success(speed))
    }.response { response in
      if let error = response.error {
        print(error.localizedDescription)
        instantSpeed(.failure(error))
      } else {
        let fileSize = Double(imageData.count)
        let elapsedTime = response.metrics?.taskInterval.duration ?? 0
        let speed = (fileSize / elapsedTime) * 8 / 1_000_000
        instantSpeedArray.append(speed)
        let averageSpeed = instantSpeedArray.reduce(0,+)/Double(instantSpeedArray.count)
        completion(averageSpeed)
      }
    }
  }
  
  func measureCurrentandAverageSpeedForImageDownload(instantSpeed: @escaping (Result<Double, Error>) -> Void, completion: @escaping (Double) -> Void) {
    var instantSpeedArray = [Double]()
    let startTime = Date()
    
    AF.download(downloadURLString).downloadProgress { progress in
      let uploadedBytes = Double(progress.completedUnitCount)
      let currentTime = Date()
      let elapsedTime = currentTime.timeIntervalSince(startTime)
      let currentSpeed = (uploadedBytes / elapsedTime) * 8 / 1_000_000
      instantSpeedArray.append(currentSpeed)
      instantSpeed(.success(currentSpeed))
    }.responseData { response in
      if let error = response.error {
        instantSpeed(.failure(error))
      } else {
        if let fileSize = response.fileURL?.path {
          let fileSizeInBytes = Double((try? FileManager.default.attributesOfItem(atPath: fileSize)[.size] as? Int) ?? 0)
          let elapsedTime = response.metrics?.taskInterval.duration ?? 0
          let speed = (fileSizeInBytes / elapsedTime) * 8 / 1_000_000
          instantSpeedArray.append(speed)
          let averageSpeed = instantSpeedArray.reduce(0,+)/Double(instantSpeedArray.count)
          completion(averageSpeed)
        } else {
          instantSpeed(.failure(NSError(domain: "DownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get file size"])))
        }
      }
    }
  }
}
