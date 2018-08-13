//
//  BHMenuPresentation.swift
//  TLT
//
//  Created by Nattapong Unaregul on 13/2/18.
//  Copyright © 2018 Toyata. All rights reserved.
//

import UIKit
protocol BHMenuPresentationDelegate {
    func requestDismiss()
}
public class BHMenuPresentation: UIPresentationController {
    var bhDelegate : BHMenuPresentationDelegate?
    
    public var dimmingView: UIView!
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor.black
        self.dimmingView.alpha = 0.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissPresentationView(sender:)))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    @objc func dismissPresentationView(sender : UITapGestureRecognizer){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    override public func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        dimmingView.frame = presentingViewController.view.bounds
        containerView?.addSubview(dimmingView)
        guard let coordinator = presentedViewController.transitionCoordinator else {
            return
        }
        coordinator.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 0.5
        }, completion: nil)
    }
    override public func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let coordinator = presentedViewController.transitionCoordinator else {
            return
        }
        coordinator.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }
}
