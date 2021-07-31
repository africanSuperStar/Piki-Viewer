//
//  ViewController.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/30.
//

import UIKit
import Combine


class MainViewController: UIViewController
{
    @Network<FlickrSearchResult>(key: "flicker-search-result")
    var network
    
    var bag = Set<AnyCancellable>()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        network?.accessToken = "f9cc014fa76b098f9e82f1c288379ea1"
        
        try? network?.searchFlickr(tags: "kitten", page: 1)
            .replaceError(with: [FlickrSearchResult]())
            .sink(receiveValue:
            {
                print($0.debugDescription)
            })
            
            .store(in: &bag)
    }
}

