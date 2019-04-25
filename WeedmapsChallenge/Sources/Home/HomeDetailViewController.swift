//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class HomeDetailViewController: UIViewController {
  
  // MARK: Properties
  
  private var webView: WKWebView!
  
  private var viewModel: BusinessViewModel!
  private var disposeBag: DisposeBag!
  
  // MARK: Control
  
  func configure(with business: BusinessViewModel) -> Self {
    self.viewModel = business
    return self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.webView = WKWebView()
    self.webView.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(self.webView)
    
    NSLayoutConstraint.activate([
      self.webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
    ])
    
    self.disposeBag = DisposeBag()
    self.viewModel.url
      .map { urlString in
        if let urlString = urlString {
          return URL(string: urlString)
        }
        return nil
      }
      .filter { $0 != nil }
      .map { URLRequest(url: $0!) }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (urlRequest: URLRequest) in
        self.webView.load(urlRequest)
      })
      .disposed(by: self.disposeBag)
  }
}
