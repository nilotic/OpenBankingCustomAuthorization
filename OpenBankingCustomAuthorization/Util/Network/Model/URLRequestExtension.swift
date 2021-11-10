import Foundation
import CommonCrypto
import UIKit

extension URLRequest {
    
    init(httpMethod: HTTPMethod, url: ServiceURL) {
        self.init(url: url.rawValue)
        
        // Set request
        self.httpMethod = httpMethod.rawValue
        
        guard let host = url.rawValue.host, server.rawValue.contains(host) else { return }
        set(value: "gzip",                              field: .acceptEncoding)
        set(value: UUID().uuidString,                   field: .requestID)
        set(value: validationCode,                      field: .validationCode)
        set(value: Bundle.main.bundleIdentifier ?? "",  field: .bundleIdentifier)
        set(value: Locale.current.regionCode ?? "",     field: .countryCode)
        set(value: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "", field: .appVersion)
    }
}

extension URLRequest {
    
    private var validationCode: String {
        let timestamp = UInt64(Date().timeIntervalSince1970.rounded())
        let version   = "001"
        let secretKey = "0elN7uSr7aIXmSgJnzeAt17PyqolXn"

        guard let data = "\(timestamp)\(version)\(secretKey)".data(using: .utf8) else { return "" }

        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
            CC_SHA512(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash

        }.map { String(format: "%02x", $0) }.joined()

        var extractedString = ""
        for (i, character) in hash.enumerated() where i % 16 == 0 {
            extractedString += String(character)
        }
        
        return "\(timestamp)\(version)|\(extractedString)"
    }
}

extension URLRequest {
    
    mutating func set(value: HTTPHeaderValue, field: HTTPHeaderField) {
        setValue(value.rawValue, forHTTPHeaderField: field.rawValue)
    }
    
    mutating func set(value: String, field: HTTPHeaderField) {
        setValue(value, forHTTPHeaderField: field.rawValue)
    }
    
    mutating func add(value: HTTPHeaderValue, field: HTTPHeaderField) {
        addValue(value.rawValue, forHTTPHeaderField: field.rawValue)
    }
    
    mutating func add(value: String, field: HTTPHeaderField) {
        addValue(value, forHTTPHeaderField: field.rawValue)
    }
}
 
extension URLRequest {
    
    var debugDescription: String {
        return """
               Request
               URL
               \(httpMethod ?? "") \(url?.absoluteString ?? "")\n
               HeaderField
               \(allHTTPHeaderFields?.debugDescription ?? "")\n
               Body
               \(String(data: httpBody ?? Data(), encoding: .utf8) ?? "")
               \n\n
               """
    }
}
