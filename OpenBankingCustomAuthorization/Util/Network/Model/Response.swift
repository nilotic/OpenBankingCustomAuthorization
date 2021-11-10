// 
//  Response.swift
//
//  Created by Den Jo on 2021/07/26.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct Response {
    let url: URL
    let headerFields: [AnyHashable: Any]
    let data: Data?
    let statusCode: HTTPStatusCode
}

extension Response {
    
    init(data: Data?, urlResponse: URLResponse?) throws {
        guard let urlResponse = urlResponse as? HTTPURLResponse, let url = urlResponse.url else { throw URLError(.badServerResponse) }
        
        self.url          = url
        self.headerFields = urlResponse.allHeaderFields
        self.data         = data
        
        statusCode = HTTPStatusCode(rawValue: urlResponse.statusCode) ?? .none
    }
}

extension Response: CustomDebugStringConvertible {
    
    var debugDescription: String {
        var headerFieldsDescription: String {
            guard let headerFields = headerFields as? [String: String] else { return headerFields.debugDescription }
            return headerFields.debugDescription
        }
        
        return """
               Response
               HTTP status: \(statusCode.rawValue)
               URL: \(url.absoluteString)\n
               HeaderField
               \(headerFieldsDescription))\n
               Data
               \(String(data: data ?? Data(), encoding: .utf8) ?? "")
               \n
               """
    }
}
