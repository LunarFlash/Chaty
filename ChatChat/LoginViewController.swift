// Yi

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Properties
    let ref: Firebase  = Firebase(url: BASE_URL)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        let navVC = segue.destinationViewController as! UINavigationController
        let chatVC = navVC.viewControllers.first as! ChatViewController
        
        chatVC.senderId = ref.authData.uid // Assign the local user’s ID to chatVc.senderId; this is the local ID that JSQMessagesViewController uses to coordinate messages.
        chatVC.senderDisplayName = "" // chatVc.senderDisplayName is set to empty string, since this is an anonymous chat room.
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

