import Foundation
import Alamofire
import Combine

struct StatusResponse: Decodable {}

protocol ApplicationNetworkServiceInterface: AnyObject {
    func servers() async throws -> [ServerCountry]
    func creds(id: String) async throws -> Country
    func promo(acc: String) async -> PromoResponse?
    func notify(acc: String, paywall: String) async throws -> StatusResponse
}

final class ApplicationNetworkService: ApplicationNetworkServiceInterface {
      
    func servers() async throws -> [ServerCountry] {
        return try await NetworkService.request(ApplicationEndpoint.servers).asyncValue()
    }
    
    func creds(id: String) async throws -> Country {
        return try await NetworkService.request(ApplicationEndpoint.creds(id: id)).asyncValue()
    }
    
    func promo(acc: String) async -> PromoResponse? {
        return try? await NetworkService.request(ApplicationEndpoint.promo2(acc: acc)).asyncValue()
    }
    
    func notify(acc: String, paywall: String) async throws -> StatusResponse {
        return try await NetworkService.request(ApplicationEndpoint.notify(acc: acc, paywall: paywall)).asyncValue()
    }
    
}

enum ApplicationEndpoint: URLRequestConvertible {
    
    static let baseURL: String = "https://shlcnctbck.com/vpn"
    
    case servers
    case creds(id: String)
    case promo2(acc: String)
    case notify(acc: String, paywall: String)
    
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
        case .servers, .creds, .promo2, .notify:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .servers:
            return "servers"
        case .creds:
            return "creds"
        case .promo2:
            return "promo2"
        case .notify:
            return "notify"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .creds(let id):
            return ["id": id]
        case .promo2(let acc):
            return ["acc": acc]
        case .notify(let acc, let paywall):
            return ["acc": acc, "paywall": paywall]
        default:
            return nil
        }
    }
    
}
