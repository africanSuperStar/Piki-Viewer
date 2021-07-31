//
//  ViewController.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/30.
//

import UIKit
import Combine


protocol MainViewDelegate : AnyObject
{
    func photosGenerated()
}

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
    
    var dataSource: UICollectionViewDiffableDataSource<Section, PhotosController.Photo>!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        navigationItem.title = "Flickr Photo Search"
        
        photosController.delegate = self
        
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
        let cellRegistration = UICollectionView.CellRegistration<PhotoCell, PhotosController.Photo>
        {
            (cell, indexPath, photo) in
            
            cell.imageView.image = UIImage(data: photo.imageData)
            cell.label.text      = photo.flickrSearch.title
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PhotosController.Photo>(
            collectionView: photosCollectionView
        ) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: PhotosController.Photo) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    /// - Tag: PhotosPerformQuery
    
    func performQuery(with filter: String?)
    {
        photosController.searchPhotos(with: "kittens", page: 1)
    }
}

extension MainViewController : MainViewDelegate
{
    func photosGenerated()
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotosController.Photo>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(photosController.photos)
 
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension MainViewController
{
    func createLayout() -> UICollectionViewLayout
    {
        let layout = UICollectionViewCompositionalLayout
        {
            (
                sectionIndex:      Int,
                layoutEnvironment: NSCollectionLayoutEnvironment
            )
            -> NSCollectionLayoutSection in
            
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = contentSize.width > 800 ? 3 : 2
            let spacing = CGFloat(10)
            
            let itemSize = NSCollectionLayoutSize(widthDimension:  .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension:  .fractionalWidth(1.0),
                                                   heightDimension: .absolute(200))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            
            section.interGroupSpacing = spacing
            section.contentInsets     = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            return section
        }
        return layout
    }

    func configureHierarchy()
    {
        view.backgroundColor = .systemBackground
    
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints      = false
        
        collectionView.backgroundColor  = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
        view.addSubview(searchBar)

        let views = ["cv": collectionView, "searchBar": searchBar]
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[cv]|", options: [], metrics: nil, views: views)
        )
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[searchBar]|", options: [], metrics: nil, views: views)
        )
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:[searchBar]-20-[cv]|", options: [], metrics: nil, views: views)
        )
        
        constraints.append(searchBar.topAnchor.constraint(
            equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0)
        )
        
        NSLayoutConstraint.activate(constraints)
        photosCollectionView = collectionView

        searchBar.delegate = self
    }
}

extension MainViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        performQuery(with: searchText)
    }
}
