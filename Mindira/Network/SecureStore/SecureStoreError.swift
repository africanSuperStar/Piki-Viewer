//
//  SecureStoreError.swift
//  DataCenterPlatform
//
//  Created by Cameron de Bruyn on 2020/05/21.
//  Copyright © 2020 Astrocyte. All rights reserved.
//

import Foundation


enum SecureStoreError : Error
{
    case string2DataConversionError
    case data2StringConversionError
    case unhandledError(message: String)
}

extension SecureStoreError : LocalizedError
{
    var errorDescription: String?
    {
        switch self
        {
        case .string2DataConversionError:
          return NSLocalizedString("String to Data conversion error", comment: "")
        case .data2StringConversionError:
          return NSLocalizedString("Data to String conversion error", comment: "")
        case .unhandledError(let message):
          return NSLocalizedString(message, comment: "")
        }
    }
}
