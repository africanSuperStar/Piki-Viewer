//
//  MainViewController.swift
//  MindiraTests
//
//  Created by Cameron de Bruyn on 2021/08/01.
//

import XCTest
@testable import Mindira


class MainViewControllerTest: XCTestCase
{
    var sut: MainViewController!
    
    override func setUpWithError() throws
    {
        sut = MainViewController()
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws
    {
        sut = nil
        
        try super.tearDownWithError()
    }

    func testSUT_CanInstantiateViewController()
    {
        XCTAssertNotNil(sut)
    }

    func testSUT_CollectionViewIsNotNilAfterViewDidLoad()
    {
        XCTAssertNotNil(sut.photosCollectionView)
    }
    
    func testSUT_PhotoControllerDidLoad()
    {
        XCTAssertNotNil(sut.photosController)
    }
    
    func testSUT_ShouldSetCollectionViewDataSource()
    {
        XCTAssertNotNil(sut.dataSource)
    }
    
    func testSUT_ConformsToCollectionViewDataSource()
    {
//        XCTAssert(sut.dataSource.conforms(to: UICollectionViewDiffableDataSource<MainViewController.Section, PhotosController.Photo>.Type))
//        
//        XCTAssertTrue(sut.dataSource.responds(to: #selector(sut.dataSource.collectionView(_:numberOfItemsInSection:))),
//        XCTAssertTrue(systemUnderTest.respondsToSelector(#selector(systemUnderTest.collectionView(_:cellForItemAtIndexPath:))))
    }

}
