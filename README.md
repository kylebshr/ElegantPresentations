# ElegantPresentations

Does this need to exist? Probably not. It's very easy to implement. But I've looked around for an existing presenter that animates in the same fashion as Twitter.app *many* times, and was never able to find one — so here it is, with a few extra options too!

<img src="https://fat.gfycat.com/WideeyedMildGelada.gif" width=320>

## Installation

#### CocoaPods

````ruby
use_frameworks!

pod 'ElegantPresentations'
````

## How To Use


Add `import ElegantPresentations` to the top of your presenting view controller and Conform to the `UIViewControllerTransitioningDelegate` protocol like so:

````swift
// Conform to UIViewControllerTransitioningDelegate

func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
	return ElegantPresentations.controller(presentedViewController: presented, presentingViewController: presenting, options: [])
}
````

### If you're using storyboards

````swift
// Set the delegate on the presented view controller

override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	segue.destinationViewController.modalPresentationStyle = .Custom
  	segue.destinationViewController.transitioningDelegate = self
}
````

### If you're not using storyboards

````swift
// Set the delegate whenever you instantiate the view controller

let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("Compose")

destinationVC.modalPresentationStyle = .Custom
destinationVC.transitioningDelegate = self

presentViewController(destinationVC, animated: true, completion: nil)
````

Check out the example project for examples of both methods, and be sure to check out the PresentationOption enum! For example, you could get a presentation very similar to the compose in Mail.app with something like:

````swift
ElegantPresentations.controller(..., options: [. PresentedHeight(view.frame.height - 40)])
````

### Options

The factory method for creating the controller takes an option set, which is an array of `PresentationOption`. They are all implemented in the example project with easy toggles to try them all out.

````swift
enum PresentationOption {
    case NoDimmingView 						// Don't dim the presenting view controller
    case DismissOnDimmingViewTap 			// Tapping outside the presented view controller dismisses it
    case PresentingViewKeepsSize 			// Prevent the presenting view controller from shrinking back
    case PresentedHeight(CGFloat)			// Give the presented view controller a fixed height
    case PresentedMaximumHeight(CGFloat)	// Give the presented view controller a fixed maximum height
    case PresentedMinimumHeight(CGFloat)	// Give the presented view controller a fixed minimum height
    case PresentedPercentHeight(Double)		// Give the presented view controller a percent height (of the presenting view controller)
    case PresentedWidth(CGFloat)			// Give the presented view controller a fixed width
    case PresentedMaximumWidth(CGFloat)		// Give the presented view controller a fixed maximum width
    case PresentedMinimumWidth(CGFloat)		// Give the presented view controller a fixed minimum width
    case PresentedPercentWidth(Double)		// Give the presented view controller a percent width (of the presenting view controller)
}
````

## TODO

- [X] Adapt to rotation
- [X] Add support for minimum and maximum height
- [X] Add support for setting presented view controller's width
- [ ] Add support for horizontal (drawer) presentation animation
- [ ] Animate presenting view better when rotated

## Contribute

I'm new to creating libraries, so if I can improve this in anyway please let me know! Open an issue, make a pull request, or [reach out on twitter](https://twitter.com/kylebshr).
