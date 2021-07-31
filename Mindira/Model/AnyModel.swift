//
//  AnyModel.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation


protocol AnyModel : Codable, Identifiable where ID == String?
{
    typealias Role = Codable
}

extension AnyModel
{
    var id: String?
    {
        return UUID().uuidString
    }
}
