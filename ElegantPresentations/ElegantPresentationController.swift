//
//  ElegantPresentation.swift
//  TwitterPresentationController
//
//  Created by Kyle Bashour on 2/21/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation

typealias CoordinatedAnimation = UIViewControllerTransitionCoordinatorContext? -> Void

class ElegantPresentationController: UIPresentationController {
    
    lazy var dimmingView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        view.alpha = 0
        
        if self.options.dimmingViewTapDismisses {
            let recognizer = UITapGestureRecognizer(target: self, action: Selector("dismiss:"))
            view.addGestureRecognizer(recognizer)
        }
        
        return view
    }()
    
    let options: PresentationOptions

    init(presentedViewController: UIViewController, presentingViewController: UIViewController, options: PresentationOptions) {
        self.options = options
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        
        dimmingView.alpha = 0
        dimmingView.frame = containerView!.bounds
        containerView?.insertSubview(dimmingView, atIndex: 0)
        
        let animations: CoordinatedAnimation = { [unowned self] _ in
            self.dimmingView.alpha = self.options.dimmingViewAlpha
            self.presentingViewController.view.transform = self.options.presentingTransform
        }
        
        if let coordinator = presentingViewController.transitionCoordinator() {
            coordinator.animateAlongsideTransition(animations, completion: nil)
        }
        else {
            animations(nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        
        let animations: CoordinatedAnimation = { [unowned self] _ in
            self.dimmingView.alpha = 0
            self.presentingViewController.view.transform = CGAffineTransformIdentity
        }
        
        if let coordinator = presentingViewController.transitionCoordinator() {
            coordinator.animateAlongsideTransition(animations, completion: nil)
        }
        else {
            animations(nil)
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        presentingViewController.view.transform = CGAffineTransformIdentity
        
        coordinator.animateAlongsideTransition(nil) { [unowned self] _ in
            self.presentingViewController.view.transform = self.options.presentingTransform
            self.dimmingView.frame = self.containerView!.bounds
        }
    }
    
    func dismiss(sender: UITapGestureRecognizer) {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        
        if options.usePercentHeight {
            return CGSize(width: parentSize.width, height: parentSize.height * CGFloat(options.presentedPercentHeight))
        }
        else if options.presentedHeight > 0 {
            return CGSize(width: parentSize.width, height: options.presentedHeight)
        }
        
        return parentSize
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        
        let parentSize = containerView!.bounds.size
        let childSize = sizeForChildContentContainer(presentedViewController, withParentContainerSize: parentSize)
        
        return CGRect(x: 0, y: parentSize.height - childSize.height, width: childSize.width, height: childSize.height)
    }
}
