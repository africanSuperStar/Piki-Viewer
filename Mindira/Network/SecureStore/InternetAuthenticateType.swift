//
//  InternetAuthenticateType.swift
//  DataCenterPlatform
//
//  Created by Cameron de Bruyn on 2020/05/21.
//  Copyright © 2020 Astrocyte. All rights reserved.
//

import Foundation


enum InternetAuthenticationType : RawRepresentable
{
    case ntlm, msn, dpa, rpa, httpBasic, httpDigest, htmlForm, `default`
  
    init ? (rawValue: String)
    {
        switch rawValue
        {
        case String(kSecAttrAuthenticationTypeNTLM):
          self = .ntlm
        case String(kSecAttrAuthenticationTypeMSN):
          self = .msn
        case String(kSecAttrAuthenticationTypeDPA):
          self = .dpa
        case String(kSecAttrAuthenticationTypeRPA):
          self = .rpa
        case String(kSecAttrAuthenticationTypeHTTPBasic):
          self = .httpBasic
        case String(kSecAttrAuthenticationTypeHTTPDigest):
          self = .httpDigest
        case String(kSecAttrAuthenticationTypeHTMLForm):
          self = .htmlForm
        case String(kSecAttrAuthenticationTypeDefault):
          self = .default
        default:
          self = .default
        }
    }
  
    var rawValue: String
    {
        switch self
        {
        case .ntlm:
          return String(kSecAttrAuthenticationTypeNTLM)
        case .msn:
          return String(kSecAttrAuthenticationTypeMSN)
        case .dpa:
          return String(kSecAttrAuthenticationTypeDPA)
        case .rpa:
          return String(kSecAttrAuthenticationTypeRPA)
        case .httpBasic:
          return String(kSecAttrAuthenticationTypeHTTPBasic)
        case .httpDigest:
          return String(kSecAttrAuthenticationTypeHTTPDigest)
        case .htmlForm:
          return String(kSecAttrAuthenticationTypeHTMLForm)
        case .default:
          return String(kSecAttrAuthenticationTypeDefault)
        }
    }
}
