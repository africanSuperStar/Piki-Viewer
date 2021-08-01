//
//  NetworkCenterErrors.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import Foundation


enum NetworkCenterError : Error
{
    case failedToBuildRequest
    case failedToCastToAutoAnyModel
    case failedToEncodeBodyForHttpRequest(_ type: Encodable)
    case failedToCreateURLWithCredentials
    case failedToCreateURLWithRefreshToken
    case failedToDecodeCacheManagerObject(_ type: CacheKeys)
    case failedToBuildURLWithHostAndPort
    case failedToSaveBearerToken
    case failedToSaveRefreshToken
    case expiredAccessToken
    case failedToDecodeJWTToken
    case failedToDecodeItems
    case expiredRefreshToken
    case failedToRetrieveValue
    case failedToRetrieveRefreshToken
    case failedToRetrieveAccessToken
    case failedToGetStatusCode
    case failedStatusCode(code: Int)
    case failedToConnectToServer
    case failedToTrustChallenge(error: Error)
}
