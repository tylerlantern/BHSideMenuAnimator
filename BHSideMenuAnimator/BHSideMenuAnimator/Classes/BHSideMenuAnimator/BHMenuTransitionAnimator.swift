//
//  BHMenuTransitionHandler.swift
//  TLT
//
//  Created by Nattapong Unaregul on 13/2/18.
//  Copyright © 2018 Toyata. All rights reserved.
//
import UIKit

enum BHAnimationType {
    case sideMenu
    case popup
}

protocol BHAnimation: UIViewControllerAnimatedTransitioning {
    var fromVcType : UIViewController.Type! { get }
    var toVcType : UIViewController.Type! { get }
}

class BHMenuTransitionAnimator: NSObject, BHAnimation {
    lazy var animator : UIViewPropertyAnimator = UIViewPropertyAnimator()
    var fromVcType : UIViewController.Type!
    var toVcType : UIViewController.Type!
    init(fromVcType : UIViewController.Type , toVcType : UIViewController.Type  ) {
        super.init()
        self.fromVcType = fromVcType
        self.toVcType = toVcType
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        transitionContext.viewController(forKey: .from)
        let fromVc = transitionContext.viewController(forKey: .from)!
        let toVc = transitionContext.viewController(forKey: .to)!
        if  fromVc.isKind(of: fromVcType){
            let targetWidth = fromVc.view.frame.width * 0.85
            toVc.view.frame = CGRect(x: targetWidth * -1, y: 0, width: targetWidth, height: fromVc.view.frame.height)
            containerView.addSubview(toVc.view)
            UIView.animate(withDuration: 0.33, animations: {
                toVc.view.frame.origin.x = 0
            }, completion: { (isDone) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled )
            })
        }else {
            UIView.animate(withDuration: 0.33, animations: {
                fromVc.view.frame.origin.x = fromVc.view.frame.width * -1
            }, completion: { (isDone) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled )
            })
        }
    }
}

class BHPopupTransitionAnimator: NSObject, BHAnimation {
    lazy var animator : UIViewPropertyAnimator = UIViewPropertyAnimator()
    var fromVcType : UIViewController.Type!
    var toVcType : UIViewController.Type!
    var size: CGSize
    init(fromVcType : UIViewController.Type , toVcType : UIViewController.Type, size: CGSize = CGSize.zero) {
        self.size = size
        super.init()
        self.fromVcType = fromVcType
        self.toVcType = toVcType
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        transitionContext.viewController(forKey: .from)
        let fromVc = transitionContext.viewController(forKey: .from)!
        let toVc = transitionContext.viewController(forKey: .to)!
        if  fromVc.isKind(of: fromVcType){
            let targetWidth = size.width > 0 ? size.width : fromVc.view.frame.width * 0.88
            let targetHeight = size.height > 0 ? size.height : fromVc.view.frame.height * 0.88
            toVc.view.frame = CGRect(x: (fromVc.view.frame.size.width - targetWidth)/2, y: (fromVc.view.frame.size.height - targetHeight)/2, width: targetWidth, height: targetHeight)
            containerView.addSubview(toVc.view)
            let oldFrame = toVc.view.frame
            toVc.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            toVc.view.frame = oldFrame
            toVc.view.alpha = 0.0
            UIView.animate(withDuration: 0.33, animations: {
//                toVc.view.frame.size = CGSize(width: targetWidth, height: targetHeight)
                toVc.view.alpha = 1.0
            }, completion: { (isDone) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled )
            })
        }else {
            UIView.animate(withDuration: 0.33, animations: {
                fromVc.view.alpha = 0.0
            }, completion: { (isDone) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled )
            })
        }
    }
}
