
//  Created by Nattapong Unaregul on 13/2/18.
import UIKit
@objc protocol BHSideMenuAnimatorDelegate {
    @objc optional func requestDismiss()
}

class BHSideMenuAnimator: NSObject {
    var delegate : BHSideMenuAnimatorDelegate?
    var fromVcType : UIViewController.Type
    var toVcType : UIViewController.Type
    var transitionAnimator : BHAnimation!
    var presentationAnimator : BHMenuPresentation?
    lazy var interactionTransition = BHMenuInteraction()
    var animationType: BHAnimationType
    init(instance :  BHSideMenuAnimatorDelegate,fromVcType : UIViewController.Type , toVcType : UIViewController.Type, animationType: BHAnimationType = .sideMenu ) {
        self.animationType = animationType
        self.fromVcType = fromVcType
        self.toVcType = toVcType
        super.init()
        self.delegate = instance
        switch animationType {
        case .sideMenu:
            transitionAnimator =  BHMenuTransitionAnimator(fromVcType: fromVcType, toVcType: toVcType)
            break
        case .popup:
            transitionAnimator =  BHPopupTransitionAnimator(fromVcType: fromVcType, toVcType: toVcType)
            break
        }
    }
    func setSizeForPopup(size: CGSize) {
        if !transitionAnimator.isKind(of: BHPopupTransitionAnimator.self) {
            return
        }
        transitionAnimator = BHPopupTransitionAnimator(fromVcType: fromVcType, toVcType: toVcType, size: size)
    }
}

extension BHSideMenuAnimator : UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        switch animationType {
        case .sideMenu:
            return interactionTransition.transitionInProgress ? interactionTransition : nil
        case .popup:
            break
        }
        return nil
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentationAnimator = BHMenuPresentation(presentedViewController: presented, presenting: presenting)
        presentationAnimator?.bhDelegate = self
        switch animationType {
        case .sideMenu:
            interactionTransition.attachViewController(presented)
            interactionTransition.setUpGestureOnView(view: presentationAnimator?.dimmingView)
            interactionTransition.setUpGestureOnView(view: presented.view)
        case .popup:
            break
        }
        return presentationAnimator
    }
}
extension BHSideMenuAnimator : BHMenuPresentationDelegate {
    func requestDismiss() {
        delegate?.requestDismiss?()
    }
}
