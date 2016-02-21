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
    

    var options: [PresentationOption] {
        var options = [PresentationOption]()
        
        if !shrinkPresentingViewSwitch.on { options.append(.PresentingViewKeepsSize) }
        if !dimPresentingViewSwitch.on { options.append(.NoDimmingView) }
        if dismissOnTapSwitch.on { options.append(.DismissOnDimmingViewTap) }
        
        if let heightValue = Double(heightTextField.text!) {
            if heightSegment.selectedSegmentIndex == 0 { options.append(.PresentedPercentHeight(heightValue)) }
            else { options.append(.PresentedHeight(CGFloat(heightValue))) }
        }
        
        return options
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) { }
    
    @IBAction func codeButtonPressed(sender: UIBarButtonItem) {
     
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("Compose")
        
        destinationVC.modalPresentationStyle = .Custom
        destinationVC.transitioningDelegate = self
                
        presentViewController(destinationVC, animated: true, completion: nil)
    }
    
    @IBAction func heightSegmentDidChange(sender: UISegmentedControl) {
        heightLabel.text = sender.selectedSegmentIndex == 0 ? "Percent Value:" : "Constant Value:"
        heightTextField.text = sender.selectedSegmentIndex == 0 ? "1.0" : "200"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.modalPresentationStyle = .Custom
        segue.destinationViewController.transitioningDelegate = self
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return ElegantPresentations.Controller(presentedViewController: presented, presentingViewController: presenting, options: options)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
