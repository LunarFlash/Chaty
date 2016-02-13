// Yi

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Properties
    let ref: Firebase  = Firebase(url: BASE_URL)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginDidTouch(sender: AnyObject) {
        
        ref.authAnonymouslyWithCompletionBlock { (error, authData) -> Void in
            if error != nil {  // Check for an authentication error.
                print(error.description)
                return
            }
            // Inside of the closure, trigger the segue to move to ChatViewController.
            print(self.ref.authData)
            self.performSegueWithIdentifier("LoginToChat", sender: self)
        }
        
    }
    
}

