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
    

    var options: Set<PresentationOption> {
        var options = Set<PresentationOption>()
        
        if !shrinkPresentingViewSwitch.isOn { options.insert(.presentingViewKeepsSize) }
        if !dimPresentingViewSwitch.isOn { options.insert(.noDimmingView) }
        if dismissOnTapSwitch.isOn { options.insert(.dismissOnDimmingViewTap) }
        
        if let heightValue = Double(heightTextField.text!) {
            if heightSegment.selectedSegmentIndex == 0 { options.insert(.presentedPercentHeight(heightValue)) }
            else { options.insert(.presentedHeight(CGFloat(heightValue))) }
        }
        
        return options
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) { }
    
    @IBAction func codeButtonPressed(_ sender: UIBarButtonItem) {
     
        let destinationVC = storyboard!.instantiateViewController(withIdentifier: "Compose")
        
        destinationVC.modalPresentationStyle = .custom
        destinationVC.transitioningDelegate = self
                
        present(destinationVC, animated: true, completion: nil)
    }
    
    @IBAction func heightSegmentDidChange(_ sender: UISegmentedControl) {
        heightLabel.text = sender.selectedSegmentIndex == 0 ? "Percent Value:" : "Constant Value:"
        heightTextField.text = sender.selectedSegmentIndex == 0 ? "1.0" : "200"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = self
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ElegantPresentations.controller(presentedViewController: presented, presentingViewController: presenting, options: options)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
