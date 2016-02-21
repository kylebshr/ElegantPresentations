# TwitterPresentationController

Does this need to exist? Probably not. It's very easy to implement. But I've looked around for a presenter that animates in the same fashion as Twitter.app *many* times, and was never able to find one — so here it is!

<img src="https://zippy.gfycat.com/NarrowThickCod.gif" width=200>

## Installation

#### CocoaPods

````ruby
use_frameworks!

pod 'TwitterPresentationController'
````

## How To Use


Add `import TwitterPresentationController` to the top of your presenting view controller and Conform to the `UIViewControllerTransitioningDelegate` protocol like so:

````swift
// Conform to UIViewControllerTransitioningDelegate

func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    return TwitterPresentationController(presentedViewController: presented, presentingViewController: presenting)
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

Check out the example project for examples of both methods.

## Contribute

I'm new to creating libraries, so if I can improve this in anyway please let me know! Open an issue, make a pull request, or [reach out on twitter](https://twitter.com/kylebshr).

-

This framework is not created or endorsed by Twitter 🙂