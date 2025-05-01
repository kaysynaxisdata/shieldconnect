import Foundation
import UIKit
import SwiftUI
import CoreLocation

struct DataInfoDTO {
    var item: DataItem
    var dataString: String
}

enum DataItem: CaseIterable {
    case ip
    case country
    case city
    case timezone

    var title: String {
        switch self {
            case .ip:
                return "IP"
            case .country:
                return "Country"
            case .city:
                return "City"
            case .timezone:
                return "Timezone"
        }
    }
}

struct IPInfo: Codable {
    var ip: String?
    var postal: String?
    var country: String?
    var city: String?
    var timezone: String?
    var loc: String?
    
    var coords: CLLocationCoordinate2D? {
        guard let coordinats = loc?.components(separatedBy: ","), coordinats.count == 2 else {
            return nil
        }
        
        guard let latitude = coordinats.first, let longitude = coordinats.last, let lat = Double(latitude), let lon = Double(longitude) else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func toItems() -> [DataInfoDTO] {
        let ip = DataInfoDTO(item: .ip, dataString: self.ip ?? "-")
        let country = DataInfoDTO(item: .country, dataString: self.country ?? "-")
        let location = DataInfoDTO(item: .city, dataString: self.city ?? "-")
        let timezone = DataInfoDTO(item: .timezone, dataString: self.timezone ?? "-")
        return [ip, country, location, timezone]
    }
    
}
