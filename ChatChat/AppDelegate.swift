/*
http://www.raywenderlich.com/122148/firebase-tutorial-real-time-chat
*/

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  override init() {
    Firebase.defaultConfig().persistenceEnabled = true
  }

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    return true
  }

}

