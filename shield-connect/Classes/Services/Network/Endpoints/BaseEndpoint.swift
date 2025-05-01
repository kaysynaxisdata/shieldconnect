import Foundation
import Alamofire
import Combine

protocol BaseNetworkServiceInterface: AnyObject {
    func info() -> AnyPublisher<IPInfo, ErrorResponse>
}

final class BaseNetworkService: BaseNetworkServiceInterface {
      
    func info() -> AnyPublisher<IPInfo, ErrorResponse> {
        return NetworkService.request(BaseEndpoint.info)
    }
    
}

enum BaseEndpoint: URLRequestConvertible {
    
    static let baseURL: String = "https://ipinfo.io/json"
    
    case info
    
    func asURLRequest() throws -> URLRequest {
        let url = try BaseEndpoint.baseURL.asURL()
        var urlRequest = URLRequest(url: url)
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    private var method: HTTPMethod {
        switch self {
        case .info:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .info:
            return ""
        }
    }
    
    private var parameters: Parameters? {
        return nil
    }
    
}
