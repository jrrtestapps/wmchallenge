//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
  
  // MARK: Properties
  
  @IBOutlet private var collectionView: UICollectionView!
  
  private var searchController = UISearchController(searchResultsController: nil)
  private var searchResults = [Business]()
  
  // Moved to ViewModel
  // private var searchDataTask: URLSessionDataTask?
  
  private(set) var viewModel: HomeViewModel!
  private var disposeBag: DisposeBag!
  
  // MARK: Lifecycle
  
  func setup(viewModel: HomeViewModel) -> Self {
    self.viewModel = viewModel
    return self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Weedmaps Challenge"
    
    self.collectionView.allowsMultipleSelection = false
    self.collectionView.showsHorizontalScrollIndicator = false
    self.collectionView.alwaysBounceVertical = true
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    
    (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 200, height: 200)
    
    self.collectionView.register(BusinessCell.self, forCellWithReuseIdentifier: BusinessCell.identifier)
    
    self.searchController.searchResultsUpdater = self
    self.searchController.searchBar.placeholder = "Search Yelp!"
    self.searchController.obscuresBackgroundDuringPresentation = false
    self.navigationItem.searchController = self.searchController
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.definesPresentationContext = true
    
    self.disposeBag = DisposeBag()
    bindViewModel()
  }
  
  private func bindViewModel() {
    self.viewModel.sectionUpdates
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: { _ in
        self.collectionView.reloadData()
      })
      .disposed(by: self.disposeBag)
  }
}

// MARK: UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // IMPLEMENT: Be sure to consider things like network errors
    // and possible rate limiting from the Yelp API. If the user types
    // very quickly, how will you prevent unnecessary requests from firing
    // off? Be sure to leverage the searchDataTask and use it wisely!
    self.viewModel.searchTerm.accept(searchController.searchBar.text)
  }
}

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // IMPLEMENT:
    // 1a) Present the user with a UIAlertController (action sheet style) with options
    // to either display the Business's Yelp page in a WKWebView OR bump the user out to
    // Safari. Both options should display the Business's Yelp page details
    collectionView.deselectItem(at: indexPath, animated: true)
    guard let cell = collectionView.cellForItem(at: indexPath) as? BusinessCell else { return }
    self.viewModel.didSelectBusiness(cell.viewModel)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let businessViewModel = (cell as? BusinessCell)?.viewModel
    businessViewModel?.fetchImage()
    if businessViewModel === self.viewModel.businesses.last {
      self.viewModel.loadAdditionalItems.accept(())
    }
  }
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.viewModel.businesses.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let businessViewModel = self.viewModel.businesses[indexPath.row]
    return (collectionView.dequeueReusableCell(withReuseIdentifier: BusinessCell.identifier, for: indexPath) as! BusinessCell)
      .setup(viewModel: businessViewModel, collectionViewWidth: { collectionView.frame.width })
  }
}
