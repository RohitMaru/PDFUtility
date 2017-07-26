//
//  ViewController.swift
//  PDFUtility
//
//  Created by Rohit Marumamula on 7/23/17.
//  Copyright © 2017 Rohit Marumamula. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class ViewController: UIViewController {

    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    
    private let service = GTLRGmailService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        let signInDelegate = PDFUGIDSignInDelegate.sharedInstance
        
        //Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.signInSuccess), name: NSNotification.Name(rawValue: signInDelegate.signInNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.signOutSuccess), name: NSNotification.Name(rawValue: signInDelegate.signOutNotification), object: nil)
    }
    
    @IBAction func gmailSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func gmailSignout(_ sender: Any) {
        GIDSignIn.sharedInstance().disconnect()
    }
    
    @objc func signInSuccess(_ notification:Notification) {
        print("sign in successful")
        
        let spreadsheetId = "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms"
        let range = "Class Data!A2:E"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetId, range:range)
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
        
    }
    /*
https://github.com/google/google-api-objectivec-client-for-rest/wiki
     
     GTLRDriveService *service = self.driveService;
     
     GTLRDrive_File *folder = [GTLRDrive_File object];
     folder.name = @"New Folder Name"
     folder.mimeType = @"application/vnd.google-apps.folder";
     
     GTLRDriveQuery_FilesCreate *query =
     [GTLRDriveQuery_FilesCreate queryWithObject:folderObj
     uploadParameters:nil];
     [service executeQuery:query
     completionHandler:^(GTLRServiceTicket *callbackTicket,
     GTLRDrive_File *folderItem,
     NSError *callbackError) {
     // Callback
     if (callbackError == nil) {
     // Succeeded.
     }
     }];
 */
    @objc func signOutSuccess(_ notification:Notification) {
        print("sign out successful")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

