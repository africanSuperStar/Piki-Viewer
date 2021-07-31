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
    enum Section: CaseIterable
    {
        case main
    }
    
    // MARK: Stored Properties
    
    var nameFilter: String?

    let photosController = PhotosController()
    
    // MARK: Lazy View Properties
    
    lazy var searchBar = UISearchBar(frame: .zero)
    
    lazy var photosCollectionView: UICollectionView = {
        
        return UICollectionView()
        
    }()
    
    // MARK: DataSource
    
    var dataSource: UICollectionViewDiffableDataSource<Section, PhotosController.Mountain>!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        navigationItem.title = "Flickr Photo Search"
        
        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)
    }
}

extension MainViewController
{
    /// - Tag: FlickrPhotosDataSource
    
    func configureDataSource()
    {
        let cellRegistration = UICollectionView.CellRegistration<LabelCell, PhotosController.Mountain>
        {
            (cell, indexPath, mountain) in
            
            cell.label.text = mountain.name
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, MountainsController.Mountain>(collectionView: mountainsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: MountainsController.Mountain) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    /// - Tag: MountainsPerformQuery
    func performQuery(with filter: String?) {
        let mountains = mountainsController.filteredMountains(with: filter).sorted { $0.name < $1.name }

        var snapshot = NSDiffableDataSourceSnapshot<Section, MountainsController.Mountain>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mountains)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
