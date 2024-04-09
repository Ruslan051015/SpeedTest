import Foundation
import Alamofire

// Сервис для выполнения запросов в сеть с помощью библиотеки Alamofire
final class NetworkServiceWithAlamofire {
  static let shared = NetworkServiceWithAlamofire(); private init() { }
  
  func fetchData(url: String, instantSpeed: @escaping (Result<Double, Error>) -> Void, completion: @escaping (Double) -> Void) {
    let iterations = 5
    var instantSpeedArray = [Double]()
    var group = DispatchGroup()
    
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
}
