//
//  ViewController.swift
//  Example
//
//  Created by Kyle Bashour on 2/20/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import ElegantPresentations

class ViewController: UITableViewController, UIViewControllerTransitioningDelegate {

    
    @IBOutlet weak var shrinkPresentingViewSwitch: UISwitch!
    @IBOutlet weak var dimPresentingViewSwitch: UISwitch!
    @IBOutlet weak var dismissOnTapSwitch: UISwitch!
    @IBOutlet weak var heightSegment: UISegmentedControl!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var widthSegment: UISegmentedControl!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var widthLabel: UILabel!
    
    var ltrTransitionDelegate: ElegantPresentationLeftToRightTransitionDelegate?

    var options: Set<PresentationOption> {
        var options = Set<PresentationOption>()
        
        if !shrinkPresentingViewSwitch.on { options.insert(.PresentingViewKeepsSize) }
        if !dimPresentingViewSwitch.on { options.insert(.NoDimmingView) }
        if dismissOnTapSwitch.on { options.insert(.DismissOnDimmingViewTap) }
        
        if let heightValue = Double(heightTextField.text!) {
            if heightSegment.selectedSegmentIndex == 0 { options.insert(.PresentedPercentHeight(heightValue)) }
            else { options.insert(.PresentedHeight(CGFloat(heightValue))) }
        }
        
        if let widthValue = Double(widthTextField.text!) {
            if widthSegment.selectedSegmentIndex == 0 { options.insert(.PresentedPercentWidth(widthValue)) }
            else { options.insert(.PresentedWidth(CGFloat(widthValue))) }
        }
        
        return options
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) { }
    
    @IBAction func codeButtonPressed(sender: UIBarButtonItem) {
     
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("Compose")
        
        destinationVC.modalPresentationStyle = .Custom
        
        if let widthValue = Double(widthTextField.text!) {
            if (widthSegment.selectedSegmentIndex == 0 && widthValue != 1.0) || widthSegment.selectedSegmentIndex != 0 {
                self.ltrTransitionDelegate = ElegantPresentationLeftToRightTransitionDelegate(options: options)
                destinationVC.transitioningDelegate = self.ltrTransitionDelegate
            }
        }
        
        if destinationVC.transitioningDelegate == nil {
            destinationVC.transitioningDelegate = self
        }
                
        presentViewController(destinationVC, animated: true, completion: nil)
    }
    
    @IBAction func heightSegmentDidChange(sender: UISegmentedControl) {
        heightLabel.text = sender.selectedSegmentIndex == 0 ? "Percent Value:" : "Constant Value:"
        heightTextField.text = sender.selectedSegmentIndex == 0 ? "1.0" : "200"
    }
    
    @IBAction func widthSegmentDidChange(sender: UISegmentedControl) {
        widthLabel.text = sender.selectedSegmentIndex == 0 ? "Percent Value:" : "Constant Value:"
        widthTextField.text = sender.selectedSegmentIndex == 0 ? "1.0" : "200"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.modalPresentationStyle = .Custom
        segue.destinationViewController.transitioningDelegate = self
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return ElegantPresentations.controller(presentedViewController: presented, presentingViewController: presenting, options: options)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
