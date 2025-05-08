import Foundation
import Alamofire
import Combine

protocol ApplicationNetworkServiceInterface: AnyObject {
    func servers() async throws -> [ServerCountry]
    func creds(id: String) async throws -> Country
}

final class ApplicationNetworkService: ApplicationNetworkServiceInterface {
      
    func servers() async throws -> [ServerCountry] {
        return try await NetworkService.request(ApplicationEndpoint.servers).asyncValue()
    }
    
    func creds(id: String) async throws -> Country {
        return try await NetworkService.request(ApplicationEndpoint.creds(id: id)).asyncValue()
    }
    
}

enum ApplicationEndpoint: URLRequestConvertible {
    
    static let baseURL: String = "https://shlcnctbck.com/vpn"
    
    case servers
    case creds(id: String)
    
    func asURLRequest() throws -> URLRequest {
        let url = try ApplicationEndpoint.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

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
        case .servers, .creds:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .servers:
            return "servers"
        case .creds:
            return "creds"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .creds(let id):
            return ["id": id]
        default:
            return nil
        }
    }
    
}
