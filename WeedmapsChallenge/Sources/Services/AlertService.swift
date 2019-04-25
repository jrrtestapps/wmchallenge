//
//  AlertService.swift
//  WeedmapsChallenge
//
//  Created by Jason Rapai on 4/24/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

protocol AlertServiceProtocol: class {
  @discardableResult
  func setup(rootViewController: UIViewController) -> Self
  func actionSheet(actions: [ActionSheetAction])
  func prompt(title: String, body: String, actionTitle: String?, actionHandler: (() -> Void)?)
}

struct ActionSheetAction {
  let text: String
  let handler: (() -> Void)?
}

class AlertService: AlertServiceProtocol {
  private var rootViewController: UIViewController?
  
  @discardableResult
  func setup(rootViewController: UIViewController) -> Self {
    self.rootViewController = rootViewController
    return self
  }
  
  private func present(_ viewController: UIViewController) {
    DispatchQueue.main.async {
      self.rootViewController?.present(viewController, animated: true)
    }
  }
  
  func actionSheet(actions: [ActionSheetAction]) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actions.forEach { action in
      let alertAction = UIAlertAction(title: action.text, style: .default, handler: { _ in action.handler?() })
      alertController.addAction(alertAction)
    }
    
    if let popoverController = alertController.popoverPresentationController,
      let rootViewController = self.rootViewController {
      popoverController.sourceView = rootViewController.view
      popoverController.sourceRect = CGRect(
        x: rootViewController.view.bounds.midX,
        y: rootViewController.view.bounds.midY,
        width: 0, height: 0)
      popoverController.permittedArrowDirections = []
    }
    present(alertController)
  }
  
  func prompt(title: String, body: String, actionTitle: String?, actionHandler: (() -> Void)?) {
    let action = UIAlertAction(title: actionTitle ?? "OK", style: .default, handler: { _ in actionHandler?() })
    let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
    alertController.addAction(action)
    present(alertController)
  }
}
