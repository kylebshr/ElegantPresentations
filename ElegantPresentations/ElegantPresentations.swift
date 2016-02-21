//
//  ElegantPresentations.swift
//  TwitterPresentationController
//
//  Created by Kyle Bashour on 2/21/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

public struct ElegantPresentations {
    
    public static func Controller(presentedViewController presented: UIViewController,
                presentingViewController presenting: UIViewController,
                options: [PresentationOption]) -> UIPresentationController
    {
        
        let options = PresentationOptions(options: options)
        
        return ElegantPresentationController(presentedViewController: presented, presentingViewController: presenting, options: options)
    }
}

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

public enum PresentationOption {
    case NoDimmingView
    case DismissOnDimmingViewTap
    case PresentingViewKeepsSize
    case PresentedHeight(CGFloat)
    case PresentedPercentHeight(Double)
}
