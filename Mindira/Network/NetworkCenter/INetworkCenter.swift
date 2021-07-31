//
//  INetworkCenter.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation
import Combine


protocol INetworkCenter
{
    associatedtype _T: AnyModel
    
    var session: URLSession { get set }
    
    var _key: String  { get set }
    var host: String? { get set }
    
    var accessToken: String? { get set }

    func getItem <T: _T.Role> (
        _ host:      String,
        path:        String,
        with params: [String : Any]?,
        headers:     [String : String]?,
        retries:     Int
    ) -> AnyPublisher <T, Error>
    
    func getItems <T: _T.Role> (
        _ host:      String,
        path:        String,
        with params: [String : Any]?,
        headers:     [String : String]?,
        retries:     Int
    ) -> AnyPublisher <[T], Error>
}
