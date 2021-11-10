// 
//  KoreaMobileCertificateRequest.swift
//
//  Created by Den Jo on 2021/08/19.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct KoreaMobileCertificateRequest {
    let certificate: String
    let url: URL
    let isAdded: Bool
    var terms = [false, false, false]
    
    private let type   = ""
    private let device = ""
}

extension KoreaMobileCertificateRequest: Encodable {

    private enum Key: String, CodingKey {
        case certificate    = "tr_cert"
        case url            = "tr_url"
        case isAdded        = "tr_add"
        case isTerms1Agreed = "chkTrms1"
        case isTerms2Agreed = "chkTrms2"
        case isTerms3Agreed = "chkTrms3"
        case type
        case device
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(certificate, forKey: .certificate) } catch { throw error }
        do { try container.encode(type,        forKey: .type) }        catch { throw error }
        do { try container.encode(device,      forKey: .device) }      catch { throw error }
        
        do { try container.encode(isAdded ? "Y" : "N", forKey: .isAdded) } catch { throw error }
        
        // Terms
        do { try container.encode(terms[0] ? "on" : "off", forKey: .isTerms1Agreed) } catch { throw error }
        do { try container.encode(terms[1] ? "on" : "off", forKey: .isTerms2Agreed) } catch { throw error }
        do { try container.encode(terms[2] ? "on" : "off", forKey: .isTerms3Agreed) } catch { throw error }
        
        
        // URL
        guard let url = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw EncodingError.invalidValue(container, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Failed to encode an URL."))
        }
        
        do { try container.encode(url, forKey: .url) } catch { throw error }
    }
}
