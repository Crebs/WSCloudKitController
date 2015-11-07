//
//  WSCloudKitController.swift
//  spending
//
//  Created by Riley Crebs on 11/5/15.
//  Copyright © 2015 Riley Crebs. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

public class WSCloudKitController: NSObject {
    
    struct Container {
        // TODO: come up with a better way to identify CloudKit containers
        static let identifier = "iCloud.com.incravo.WellSpent2"
    }
    
    public func storeObject(object: AnyObject!, recordId: CKRecordID, container: CKContainer) {
        let record = CKRecord.recordFromObject(object, recordId: recordId)
        self.storeRecord(record, cloudDatabase: container.privateCloudDatabase)
    }
    
    public func storeObject(object: AnyObject!, recordId: CKRecordID) {
        let myContainer = CKContainer(identifier: Container.identifier)
        self.storeObject(object, recordId: recordId, container: myContainer)
    }
    
    public func updateRecord(object: AnyObject!, recordId: CKRecordID, container: CKContainer) {
        container.privateCloudDatabase.fetchRecordWithID(recordId) { (fetchedRecord , error) -> Void in
            if error != nil {
                // TODO: handle failure
            } else if fetchedRecord!.isKindOfClass(CKRecord.self) {
                fetchedRecord!.updateFromObject(object)
                self.storeRecord(fetchedRecord!, cloudDatabase: container.privateCloudDatabase)
            }
        }
    }
    
    public func updateRecord(object: AnyObject!, recordId: CKRecordID) {
        let myContainer = CKContainer(identifier: Container.identifier)
        self.updateRecord(object, recordId: recordId, container: myContainer)
    }
    
    private func storeRecord(record: CKRecord, cloudDatabase: CKDatabase) {
        cloudDatabase.saveRecord(record) { (savedRecord, error) -> Void in
            if (error != nil) {
                // TODO: handle failure
            } else {
                // TODO: hanlde saved record success
            }
        }
    }
    
    private func verifyUserIsSignedIntoiCloudAccount(signedIn: (Bool) -> Void)  {
        let myContainer = CKContainer(identifier: "iCloud com incravo WellSpent2")
        myContainer.accountStatusWithCompletionHandler { (status, error) -> Void in
            switch status {
            case .NoAccount:
                let alert = UIAlertController(title: NSLocalizedString("Sign in to iCloud", comment: "title to alert"), message: NSLocalizedString("Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID.", comment: "alert message"), preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Alert action for alert"), style: .Cancel, handler:nil))
                // Present Alert Controller
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController( alert, animated: true, completion: nil)
                signedIn(false)
                break
            default:
                signedIn(true)
                break
            }
        }
    }
}