//
//  FlickrAPITest.swift
//  MindiraTests
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import XCTest
import Combine

@testable import Mindera

class FlickrAPITest: XCTestCase
{
    @MockNetwork<FlickrPhotos>(key: "mock-flickr-photos")
    var networkPhotos
    
    override func setUpWithError() throws
    {
        try networkPhotos.searchFlickr(tags: "kitten", page: 1)
            .replaceError(with: FlickrPhotos(photos: nil, stat: "NO SUCCESS"))
            .receive(subscriber: AnySubscriber())
    }
    
    func testCassetteName()
    {
        XCTAssertEqual("mock-session", networkPhotos.mockSession.cassetteName)
    }
    
    func test_FlickrPhotos_URLComponents() throws
    {
        var components = URLComponents()
    
        components.scheme                   = networkPhotos.scheme
        components.host                     = networkPhotos.host
        components.path                     = networkPhotos.path ?? ""
        components.percentEncodedQueryItems = networkPhotos.urlQueryItems
        
        XCTAssertEqual(networkPhotos.scheme,     "https")
        XCTAssertEqual(networkPhotos.host,       "api.flickr.com")
        XCTAssertEqual(networkPhotos.path,       "/services/rest/")
        XCTAssertEqual(networkPhotos.queryItems, [
            "method": "flickr.photos.search",
            "api_key": networkPhotos.accessToken ?? "",
            "tags": "kitten",
            "page": "1",
            "format": "json",
            "nojsoncallback": "1"
        ])
    
        let url = components.url?.absoluteURL

        print("ABS. URL: \(components.url?.absoluteString ?? "")")

        let mockURL = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f9cc014fa76b098f9e82f1c288379ea1&tags=kitten&page=1&format=json&nojsoncallback=1")
        
        XCTAssertEqual(url?.host,           mockURL?.host)
        XCTAssertEqual(url?.port,           mockURL?.port)
        XCTAssertEqual(url?.scheme,         mockURL?.scheme)
        XCTAssertEqual(url?.pathComponents, mockURL?.pathComponents)
    }
    
    func test_FlickrPhotos_DataTask()
    {
        let url      = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f9cc014fa76b098f9e82f1c288379ea1&tags=kitten&page=1&format=json&nojsoncallback=1")
        let dataTask = networkPhotos.mockSession.dataTask(with: url!)

        XCTAssert(dataTask is SessionDataTask)

        if let dataTask = dataTask as? SessionDataTask
        {
            XCTAssertEqual(dataTask.request?.url?.absoluteString, url?.absoluteString)
        }
    }
    
    func testPlayback()
    {
        networkPhotos.mockSession.recordingEnabled = false
        
        let expectation = self.expectation(description: "Flickr Photos")

//        networkPhotos.mockSession.dataTask(with: request, completionHandler: { data, response, error in
//            XCTAssertEqual("hello", String(data: data!, encoding: String.Encoding.utf8))
//
//            let httpResponse = response as! Foundation.HTTPURLResponse
//            XCTAssertEqual(200, httpResponse.statusCode)
//
//            expectation.fulfill()
//        }) .resume()

        waitForExpectations(timeout: 1, handler: nil)
    }

}
