//
//  NetworkCenter+Token.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation
import CryptoKit


extension NetworkCenter
{
    var accessToken: String?
    {
        get
        {
            guard let token = try? secureStore?.getValue(for: "mindera.token")
            else
            {
                print("CRITICAL: Failed to retrieve access token from Secure Store")
                
                return nil
            }
            
            return token
        }
        
        set
        {
            if newValue != nil
            {
                try? secureStore?.setValue(newValue ?? "", for: "mindera.token")
            }
            else
            {
                print("CRITICAL: Failed to save access token to Secure Store")
                
                return
            }
        }
    }
}
