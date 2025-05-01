//
//  NetworkService.swift
//  pathly-vpn
//
//  Created by Александр on 09.11.2024.
//

import Foundation
import Alamofire
import Combine

#if DEBUG
final class Logger: EventMonitor {
    func requestDidResume(_ request: Request) {
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ------ Request Started: \(request)
        ------ Body Data: \(body)
        """
        NSLog(message)
    }

  func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        NSLog("------ Response Received: \(response.debugDescription)")
    }
  
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
      NSLog("------ Response Received: \(response.debugDescription) \n Result: \(response.result)")
  }
  
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) {
  }

  /// Event called during `URLSessionDataDelegate`'s `urlSession(_:dataTask:didReceive:)` method.
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
  }
}
#endif


class NetworkService {
#if DEBUG
    static let session = Session(eventMonitors: [Logger()])
#else
    static let session = AF
#endif
  
//    static let baseURL: String = {
//        return EnvironmentConfiguration.current.baseURL
//    }()
    
    static func request<T: Decodable> (_ urlConvertible: URLRequestConvertible) -> AnyPublisher<T, ErrorResponse> {
        return Future<T, ErrorResponse> { promise in
            let request = AF.request(urlConvertible).responseDecodable(of: T.self) { response in
                handleResponse(response, promise: promise)
            }
            request.resume()
        }
        .eraseToAnyPublisher()
    }
    
    private static func handleResponse<T: Decodable>(
        _ response: AFDataResponse<T>,
        idempotencyKeyIdentifier: String? = nil,
        promise: @escaping (Result<T, ErrorResponse>) -> Void) {
        let urlString = response.request?.urlRequest?.url?.absoluteURL.absoluteString
        
        switch response.result {
        case .success(let result):
            if response.response?.statusCode ?? 0 >= 400 {
                handleErrorResponse(path: urlString, response.data, promise: promise)
            } else {
                promise(.success(result))
            }
        case .failure:
            handleErrorResponse(path: urlString, response.data, promise: promise)
        }
    }

    private static func handleErrorResponse<T: Decodable>(path: String?, _ data: Data?, promise: @escaping (Result<T, ErrorResponse>) -> Void) {
        do {
            guard let data = data else {
                promise(.failure(ErrorResponse.cannotGetResponseData))
                return
            }
            
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            switch errorResponse.status {
            case 429:
                //Too Many Request Error
                promise(.failure(ErrorResponse.tooManyRequestError))
            case 401:
                //Unauthorized
//                NotificationCenter.default.post(name: .expireUserToken, object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    promise(.failure(ErrorResponse.unauthorized))
                }
            default:
                promise(.failure(errorResponse))
            }
        } catch {
            let errorResponse = ErrorResponse.cannotResponseDecode
            promise(.failure(errorResponse))
        }
    }
    
}
