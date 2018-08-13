
//  Created by Nattapong Unaregul on 14/2/18.

import UIKit
class BHMenuInteraction: UIPercentDrivenInteractiveTransition {
    var transitionInProgress = false
    var shouldCompleteTransition = false
    var const :  CGFloat = 0
    var viewController : UIViewController!
    func attachViewController(_ vc : UIViewController)  {
        viewController = vc
    }
    func setUpGestureOnView(view : UIView?){
        guard let view = view else {return}
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(sender:)))
        view.addGestureRecognizer(panGesture)
    }
    fileprivate let threshold : CGFloat = 300
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        let view = sender.view!
        let viewTranslation = sender.translation(in: view)
        switch sender.state {
        case .began:
//            CGPoint velocity = [gestureRecognizer velocityInView:yourView];
            
            
            transitionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            break
        case .changed:
            guard viewTranslation.x < 0 else {
                cancel()
                return
            }
            let absX = abs(viewTranslation.x)
            const = CGFloat(fminf(fmaxf(Float(absX / threshold), 0), 1.0))
            shouldCompleteTransition = const > 0.5
            update(const)
            break
        case .cancelled, .ended , .failed:
            if !shouldCompleteTransition || sender.state == .cancelled {
                cancel()
            } else {
                finish()
            }
            transitionInProgress = false
            break
        default:
//            print("Swift switch must be exhaustive, thus the default")
            transitionInProgress = false
            break
        }
//        sender.setTranslation( CGPoint.zero , in:  view)
    }
}
