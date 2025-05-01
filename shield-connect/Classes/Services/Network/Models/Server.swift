import Foundation

struct Server: Codable {
    
    static let SERVER_KEY = "SERVER_KEY"
    static let PSK_KEY = "PSK_KEY"
    static let KEYCHAIN_PSK_KEY = "KEYCHAIN_PSK_KEY"
    static let KEYCHAIN_PASSWORD_KEY = "KEYCHAIN_PASSWORD_KEY"
    static let KEYCHAIN_ID_KEY = "KEYCHAIN_ID_KEY"
    static let KEYCHAIN_LOGIN_KEY = "KEYCHAIN_LOGIN_KEY"
    static let KEYCHAIN_IP_KEY = "KEYCHAIN_IP_KEY"
    static let KEYCHAIN_NAME_KEY = "KEYCHAIN_NAME_KEY"
    static let KEYCHAIN_COUNTRY_KEY = "KEYCHAIN_COUNTRY_KEY"
    static let KEYCHAIN_PREMIUM_KEY = "KEYCHAIN_PREMIUM_KEY"

    public var pskEnabled: Bool {
        return psk.isEmpty != false
    }
    
    var id: Int
    var country: String
    var name: String
    var ip: String
    var login: String
    var password: String
    var psk: String
    var premium: Bool
    
    func getPSKRef() -> Data? {
        if psk.isEmpty == true { return nil }
        
        KeychainWrapper.standard.set(psk, forKey: Server.KEYCHAIN_PSK_KEY)
        return KeychainWrapper.standard.dataRef(forKey: Server.KEYCHAIN_PSK_KEY)
    }
    
    func getPasswordRef() -> Data? {
        KeychainWrapper.standard.set(password, forKey: Server.KEYCHAIN_PASSWORD_KEY)
        return KeychainWrapper.standard.dataRef(forKey: Server.KEYCHAIN_PASSWORD_KEY)
    }
    
    static func loadFromDefaults() -> Server {
        let def = UserDefaults.standard
        let server = def.string(forKey: Server.SERVER_KEY) ?? ""
        let id = def.integer(forKey: Server.KEYCHAIN_ID_KEY)
        let country = def.string(forKey: Server.KEYCHAIN_COUNTRY_KEY) ?? ""
        let ip = def.string(forKey: Server.KEYCHAIN_IP_KEY) ?? ""
        let login = def.string(forKey: Server.KEYCHAIN_LOGIN_KEY) ?? ""
        let name = def.string(forKey: Server.KEYCHAIN_NAME_KEY) ?? ""
        let password = def.string(forKey: Server.KEYCHAIN_PASSWORD_KEY) ?? ""
        let psk = def.string(forKey: Server.PSK_KEY) ?? ""
        let premium = def.bool(forKey: Server.KEYCHAIN_PREMIUM_KEY)

        return Server.init(
            id: id,
            country: country,
            name: name,
            ip: server,
            login: login,
            password: password,
            psk: psk,
            premium: premium
        )
    }
    
    func saveToDefaults() {
        let def = UserDefaults.standard
        def.set(ip, forKey: Server.SERVER_KEY)
        def.set(id, forKey: Server.KEYCHAIN_ID_KEY)
        def.set(name, forKey: Server.KEYCHAIN_NAME_KEY)
        def.set(country, forKey: Server.KEYCHAIN_COUNTRY_KEY)
        def.set(login, forKey: Server.KEYCHAIN_LOGIN_KEY)
        def.set(premium, forKey: Server.KEYCHAIN_PREMIUM_KEY)
        def.set(psk, forKey: Server.PSK_KEY)
        def.set(password, forKey: Server.KEYCHAIN_PASSWORD_KEY)
    }
    
}
