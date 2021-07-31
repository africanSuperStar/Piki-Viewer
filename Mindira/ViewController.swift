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
    @Network<FlickrPhotos>(key: "flicker-search-result")
    var network
    
    var bag = Set<AnyCancellable>()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        try? network?.searchFlickr(tags: "kitten", page: 1)
            .replaceError(with: FlickrPhotos(photos: nil, stat: "NO SUCCESS"))
            .sink(receiveValue:
            {
                print("\($0.photos?.page ?? 0)")
            })
            
            .store(in: &bag)
    }
}

