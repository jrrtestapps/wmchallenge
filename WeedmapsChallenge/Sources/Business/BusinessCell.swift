//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BusinessCell: UICollectionViewCell {
  static let identifier: String = "BusinessCell"
  
  private var isLayoutInitialized: Bool = false
  
  let imageView: UIImageView = UIImageView()
  let label: UILabel = UILabel()
  
  private var imageHeight: CGFloat {
    switch UIDevice.current.userInterfaceIdiom {
    case .pad: return 250
    case .phone: return 160
    default: return 200
    }
  }
  
  private var columns: CGFloat {
    switch UIDevice.current.userInterfaceIdiom {
    case .pad:
      switch UIDevice.current.orientation {
      case .portrait, .portraitUpsideDown: return 4
      case .landscapeLeft, .landscapeRight: return 6
      default: return 4
      }
    case .phone:
      switch UIDevice.current.orientation {
      case .portrait, .portraitUpsideDown: return 2
      case .landscapeLeft, .landscapeRight: return 4
      default: return 2
      }
    default: return 1
    }
  }
  
  private var collectionViewWidth: (() -> CGFloat)?
  private(set) var viewModel: BusinessViewModel!
  private var disposeBag: DisposeBag!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initializeLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initializeLayout()
  }
  
  private func initializeLayout() {
    if self.isLayoutInitialized { return }
    self.isLayoutInitialized = true
    
    self.contentView.addSubview(self.imageView)
    self.contentView.addSubview(self.label)
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = false
    self.imageView.contentMode = .scaleAspectFill
    self.imageView.clipsToBounds = true
    
    self.label.translatesAutoresizingMaskIntoConstraints = false
    self.label.numberOfLines = 3
    self.label.lineBreakMode = .byWordWrapping
    
    NSLayoutConstraint.activate([
      self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
      self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
      self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
      self.imageView.bottomAnchor.constraint(equalTo: self.label.topAnchor, constant: -8),
      self.imageView.heightAnchor.constraint(equalToConstant: 184),
      
      self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
      self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
      self.label.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -8)
    ])
  }
  
  @discardableResult
  func setup(viewModel: BusinessViewModel, collectionViewWidth: (() -> CGFloat)?) -> Self {
    self.collectionViewWidth = collectionViewWidth
    if self.viewModel === viewModel {
      return self
    }
    self.viewModel = viewModel
    
    self.disposeBag = DisposeBag()
    bindViewModel()
    
    return self
  }
  
  private func bindViewModel() {
    self.viewModel.name.asDriver()
      .drive(self.label.rx.text)
      .disposed(by: self.disposeBag)
    
    self.viewModel.image.asDriver()
      .drive(onNext: { image in
        if let image = image {
          UIView.transition(
            with: self.imageView,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
              self.imageView.image = image
            }, completion: nil)
        } else {
          self.imageView.image = nil
        }
      })
      .disposed(by: self.disposeBag)
  }
  
  func heightForView(width: CGFloat) -> CGFloat{
    let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 3
    label.lineBreakMode = .byWordWrapping
    label.font = self.label.font
    label.text = self.label.text
    label.sizeToFit()
    return label.frame.height + self.imageHeight + 16
  }
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    guard let _ = self.label.text else { return layoutAttributes }
    let factor: CGFloat = self.columns
    let width: CGFloat = (self.collectionViewWidth?() ?? 0.0) / factor - 4 * factor
    let rect = CGRect(x: 0, y: 0, width: width, height: heightForView(width: width))
    layoutAttributes.bounds = rect
    layoutAttributes.frame = rect
    return layoutAttributes
  }
}
