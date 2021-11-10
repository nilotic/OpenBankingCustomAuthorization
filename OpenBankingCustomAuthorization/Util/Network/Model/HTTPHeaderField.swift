
import Foundation

enum HTTPHeaderField: String {
    case contentType      = "Content-Type"
    case contentLength    = "Content-Length"
    case accept           = "Accept"
    case acceptEncoding   = "Accept-Encoding"
    case acceptLanguage   = "Accept-Language"
    case authorization    = "Authorization"
    case origin           = "Origin"
    case referer          = "Referer"
    
    case platform         = "UA-Platform"
    case platformVersion  = "UA-Platform-Version"
    case deviceMode       = "DeviceModel"
    case bundleIdentifier = "BundleIdentifier"
    case appVersion       = "AppVersion"
    case requestID        = "Request-ID"
    case validationCode   = "Validation-Code"
    case countryCode      = "Country-Code"
}
