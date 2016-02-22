//
//  ElegantPresentations.swift
//  TwitterPresentationController
//
//  Created by Kyle Bashour on 2/21/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

/**
 *  Elegant modal presentations. Contains the function `controller` for creating presentation controllers.
 */
public struct ElegantPresentations {
    
    /**
     Initializes and returns an elegant presentation controller for transitioning between the specified view controllers.
     
     - parameter presentedViewController:  The view controller being presented modally.
     - parameter presentingViewController: The view controller whose content represents the starting point of the transition.
     - parameter options:                  An options set for customizing the appearance and behavior of the presentation.
     
     - returns: An initialized presentation controller object.
     */
    public static func controller(presentedViewController presented: UIViewController,
                presentingViewController presenting: UIViewController,
                options: [PresentationOption]) -> UIPresentationController
    {
        
        let options = PresentationOptions(options: options)
        
        return ElegantPresentationController(presentedViewController: presented, presentingViewController: presenting, options: options)
    }
}

// For storing the options set in the options array
struct PresentationOptions {
    var dimmingViewAlpha: CGFloat = 1
    var dimmingViewTapDismisses = false
    var presentingTransform = CGAffineTransformMakeScale(0.93, 0.93)
    var presentedHeight: CGFloat = -1
    var presentedPercentHeight = 1.0
    var usePercentHeight = true
    
    init() { }
    
    init(options: [PresentationOption]) {
        for option in options {
            switch option {
            case .NoDimmingView: dimmingViewAlpha = 0
            case .DismissOnDimmingViewTap: dimmingViewTapDismisses = true
            case .PresentingViewKeepsSize: presentingTransform = CGAffineTransformIdentity
            case .PresentedHeight(let height):
                usePercentHeight = false
                presentedHeight = height
            case .PresentedPercentHeight(let percentHeight):
                usePercentHeight = true
                presentedPercentHeight = percentHeight
            }
        }
        
        // They tried to do both — bad!
        if presentedHeight != -1 && usePercentHeight {
            NSLog("\n-------------------------\nElegant Presentation Warning:\nDO NOT set a height and a percent height!\n-------------------------")
        }
    }
}

/**
 Options for customizing the presentation animations and behavior
 
 - NoDimmingView:           Do not dim the presenting view controller
 - DismissOnDimmingViewTap: Dismiss the presented view controller when the area outside its view is tapped
 - PresentingViewKeepsSize: Do not shrink the presenting view controller into the background
 - PresentedHeight:         Give the presenting view controller a fixed height (may not work well with rotation)
 - PresentedPercentHeight:  Give the presenting view controller a percent height of the presented view controller (should work well with rotation)
 */
public enum PresentationOption {
    case NoDimmingView
    case DismissOnDimmingViewTap
    case PresentingViewKeepsSize
    case PresentedHeight(CGFloat)
    case PresentedPercentHeight(Double)
}
