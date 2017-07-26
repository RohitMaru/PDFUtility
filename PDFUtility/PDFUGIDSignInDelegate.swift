//
//  PDFUGIDSignInDelegate.swift
//  PDFUtility
//
//  Created by Rohit Marumamula on 7/23/17.
//  Copyright © 2017 Rohit Marumamula. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class PDFUGIDSignInDelegate : NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    let signInNotification = "SignInNotification"
    let signOutNotification = "SignOutNotification"
    
    static let sharedInstance = PDFUGIDSignInDelegate()
    
    private let service = GTLRGmailService()
    
    fileprivate let appRootVC: UIViewController!
    
    private override init() {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appRootVC = appDelegate.window!.rootViewController as! ViewController
        
        super.init()
        
        // If modifying these scopes, delete your previously saved credentials by
        // resetting the iOS simulator or uninstall the app.
        let scopes = [kGTLRAuthScopeGmailModify, kGTLRAuthScopeGmailCompose]
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        
    }
    
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        appRootVC.present(alert, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
        }
        
        let signInNotification = Notification.Name(rawValue: self.signInNotification)
        NotificationCenter.default.post(name: signInNotification, object: nil, userInfo: ["user": user, "error": error, "signIn": signIn])
    }
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        let signOutNotification = Notification.Name(rawValue: self.signOutNotification)
        NotificationCenter.default.post(name: signOutNotification, object: nil, userInfo: ["user": user, "error": error, "signIn": signIn])
    }
    
    // The sign-in flow has finished selecting how to proceed, and the UI should no longer display
    // a spinner or other "please wait" element.
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    // If implemented, this method will be invoked when sign in needs to display a view controller.
    // The view controller should be displayed modally (via UIViewController's |presentViewController|
    // method, and not pushed unto a navigation controller's stack.
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        appRootVC.present(viewController, animated: true, completion: nil)
    }
    
    // If implemented, this method will be invoked when sign in needs to dismiss a view controller.
    // Typically, this should be implemented by calling |dismissViewController| on the passed
    // view controller.
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
