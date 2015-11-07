//
//  CKRecord+Extension.swift
//  WSCloudKitController
//
//  Created by Riley Crebs on 11/6/15.
//  Copyright (c) 2015 Incravo. All rights reserved.
//

import Foundation
import CloudKit

public extension CKRecord {
    
    /**
    Updates the CKRecord object from a basic NSObject.  Will only update 
    properties that conform to CKRecordValue, will skip the rest.
    
    @param object NSObject to update the responder with.
    */
    public func updateFromObject(object :AnyObject?) {
        let objectsClass: AnyClass = object!.classForCoder;
        self.updateFromObject(object, objectClass: objectsClass)
    }
    
    
    /**
    Class method To make a CKRecord object from a basic NSObject.  
    Will only handle properties that CKRecord can handle, will skip the rest.
    
    @param object NSObject to convert into a CKRecord object.
    @param recordId Record id use to create the CKRecord.
    
    @return returns a CKRecord object created from basic NSObject
    */
    public class func recordFromObject(object :AnyObject?, recordId :CKRecordID) -> CKRecord {
        let objectsClass: AnyClass = object!.classForCoder;
        let typeName: String = NSStringFromClass(objectsClass).componentsSeparatedByString(".").last!
        let record: CKRecord = CKRecord(recordType: typeName, recordID: recordId)
        record.updateFromObject(object, objectClass: objectsClass)
        return record
    }
    
    
    private func updateFromObject(object: AnyObject?, objectClass: AnyClass) {
        var count:UInt32 = 0
        let properties = class_copyPropertyList(objectClass, &count)
        for (var i:UInt32 = 0; i < count; ++i) {
            let property = properties[Int(i)]
            let cname = property_getName(property)
            let name: String = String.fromCString(cname)!
            let value: AnyObject? = object?.valueForKeyPath(name)
            if CKRecord.isValidCloudKitClass(value!) {
                self.setValue(value, forKey: name)
            }
        }
    }
    
    private class func isValidCloudKitClass(object: AnyObject) -> Bool {
        return (object.isKindOfClass(NSNumber.self)
            || object.isKindOfClass(NSString.self)
            || object.isKindOfClass(NSDate.self)
            || object.isKindOfClass(CKAsset.self)
            || object.isKindOfClass(NSData.self)
            || object.isKindOfClass(CLLocation.self)
            || object.isKindOfClass(CKReference.self)
            || object.isKindOfClass(NSArray.self))
    }
}