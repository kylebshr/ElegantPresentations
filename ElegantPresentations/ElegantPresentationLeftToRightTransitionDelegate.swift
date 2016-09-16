//
//  ElegantPresentationLeftToRightTransitionDelegate.swift
//  ElegantPresentations
//
//  Created by Lluís Ulzurrun on 14/7/16.
//  Copyright © 2016 Lluís Ulzurrun. All rights reserved.
//

import UIKit

public class ElegantPresentationLeftToRightTransitionDelegate: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let presentationOptions: Set<PresentationOption>
    let presentationAnimationDuration: NSTimeInterval
    
    public init( options: Set<PresentationOption>, duration: NSTimeInterval = 0.2 ) {
        self.presentationOptions = options
        self.presentationAnimationDuration = duration
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        #if swift(>=2.3)
        let container = transitionContext.containerView()
        #else
        guard let container = transitionContext.containerView() else { return }
        #endif
        
        enum Direction {
            case LeftToRight
            case RightToLeft
        }
        
        typealias AnimationTuple = (animationBlock: (Void) -> Void, completionBlock: (Void) -> Void)
        
        let prepare: (UIViewController, UIView, Direction) -> AnimationTuple = {
            viewController, view, direction in
            
            let finalFrame = transitionContext.finalFrameForViewController(viewController)
            let offscreenTransform = CGAffineTransformMakeTranslation(-finalFrame.width, 0)
            view.frame = finalFrame
            container.addSubview(view)
            
            switch direction {
            case .LeftToRight:
                view.transform = offscreenTransform
                return (
                    animationBlock: { view.transform = CGAffineTransformIdentity },
                    completionBlock: { view.transform = CGAffineTransformIdentity }
                )
            case .RightToLeft:
                view.transform = CGAffineTransformIdentity
                return (
                    animationBlock: { view.transform = offscreenTransform },
                    completionBlock: { view.transform = CGAffineTransformIdentity }
                )
            }
        }
        
        let animationTuple: AnimationTuple?
        
        if let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let presentedViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        {
            animationTuple = prepare(presentedViewController, toView, .LeftToRight)
        } else if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
                      let dismissedViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        {
            animationTuple = prepare(dismissedViewController, fromView, .RightToLeft)
        } else {
            animationTuple = nil
        }
        
        let duration = self.transitionDuration(transitionContext)
        
        guard let tuple = animationTuple else { return }
        
        UIView.animateWithDuration(duration, animations: tuple.animationBlock) { finished in
            tuple.completionBlock()
            transitionContext.completeTransition(finished)
        }
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.presentationAnimationDuration
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    public func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationControllerForDismissedController(
        dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    #if swift(>=2.3)
    public func presentationControllerForPresentedViewController(
        presented: UIViewController,
        presentingViewController: UIViewController?,
        sourceViewController source: UIViewController
    ) -> UIPresentationController? {
        guard let presenting = presentingViewController
        else { return nil }
        return ElegantPresentations.controller(
            presentedViewController: presented,
            presentingViewController: presenting,
            options: self.presentationOptions
        )
    }
    #else
    public func presentationControllerForPresentedViewController(
        presented: UIViewController,
        presentingViewController: UIViewController,
        sourceViewController source: UIViewController
        ) -> UIPresentationController? {
        let presenting = presentingViewController
        return ElegantPresentations.controller(
            presentedViewController: presented,
            presentingViewController: presenting,
            options: self.presentationOptions
        )
    }
    #endif
    
}
