//
//  ElegantPresentationLeftToRightTransitionDelegate.swift
//  ElegantPresentations
//
//  Created by Lluís Ulzurrun on 14/7/16.
//  Copyright © 2016 Lluís Ulzurrun. All rights reserved.
//

import UIKit

open class ElegantPresentationLeftToRightTransitionDelegate: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let presentationOptions: Set<PresentationOption>
    let presentationAnimationDuration: TimeInterval
    
    public init( options: Set<PresentationOption>, duration: TimeInterval = 0.2 ) {
        self.presentationOptions = options
        self.presentationAnimationDuration = duration
        super.init()
    }
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        enum Direction {
            case leftToRight
            case rightToLeft
        }
        
        typealias AnimationTuple = (animationBlock: (Void) -> Void, completionBlock: (Void) -> Void)
        
        let prepare: (UIViewController, UIView, Direction) -> AnimationTuple = {
            viewController, view, direction in
            
            let finalFrame = transitionContext.finalFrame(for: viewController)
            let offscreenTransform = CGAffineTransform(translationX: -finalFrame.width, y: 0)
            view.frame = finalFrame
            container.addSubview(view)
            
            switch direction {
            case .leftToRight:
                view.transform = offscreenTransform
                return (
                    animationBlock: { view.transform = CGAffineTransform.identity },
                    completionBlock: { view.transform = CGAffineTransform.identity }
                )
            case .rightToLeft:
                view.transform = CGAffineTransform.identity
                return (
                    animationBlock: { view.transform = offscreenTransform },
                    completionBlock: { view.transform = CGAffineTransform.identity }
                )
            }
        }
        
        let animationTuple: AnimationTuple?
        
        if let toView = transitionContext.view(forKey: UITransitionContextViewKey.to),
               let presentedViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        {
            animationTuple = prepare(presentedViewController, toView, .leftToRight)
        } else if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
                      let dismissedViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        {
            animationTuple = prepare(dismissedViewController, fromView, .rightToLeft)
        } else {
            animationTuple = nil
        }
        
        let duration = self.transitionDuration(using: transitionContext)
        
        guard let tuple = animationTuple else { return }
        
        UIView.animate(withDuration: duration, animations: tuple.animationBlock, completion: { finished in
            tuple.completionBlock()
            transitionContext.completeTransition(finished)
        }) 
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.presentationAnimationDuration
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    open func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    open func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    open func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return ElegantPresentations.controller(
            presentedViewController: presented,
            presentingViewController: presenting,
            options: self.presentationOptions
        )
    }
    
}
