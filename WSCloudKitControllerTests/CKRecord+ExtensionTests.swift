//
//  WSCloudKitControllerTests.swift
//  WSCloudKitControllerTests
//
//  Created by Riley Crebs on 11/6/15.
//  Copyright (c) 2015 Incravo. All rights reserved.
//

import UIKit
import XCTest
import CloudKit

class CKRecordExtensionTests: XCTestCase {
    var object: TestObject?
    var recordId: CKRecordID?
    
    override func setUp() {
        super.setUp()
        self.object = TestObject.new()
        self.recordId = CKRecordID(recordName: "testId1234")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecordFromObject_WithValidObject_ShouldReturnCKRecordSuccessfully() {
        let record = CKRecord.recordFromObject(self.object, recordId: self.recordId!)
        
        XCTAssertTrue(record.objectForKey("number").isKindOfClass(NSNumber), "")
        XCTAssertEqual(object!.number, (record.objectForKey("number") as? NSNumber)!, "")
        
        XCTAssertTrue(record.objectForKey("name").isKindOfClass(NSString), "")
        XCTAssertEqual(object!.name, (record.objectForKey("name") as? NSString)!, "")
        
        XCTAssertTrue(record.objectForKey("date").isKindOfClass(NSDate), "")
        XCTAssertEqual(object!.date, (record.objectForKey("date") as? NSDate)!, "")
    }
    
    func testUpdateFromObject_WithValidObject_ShouldUpdateRecordSuccessfully() {
        let record = CKRecord.recordFromObject(self.object, recordId: self.recordId!)
        object!.number = 5
        object!.name = "NewTestObjectName"
        object!.date = NSDate.new().dateByAddingTimeInterval(100)
        
        // Test updateFromObject
        record.updateFromObject(object)
        
        XCTAssertTrue(record.objectForKey("number").isKindOfClass(NSNumber), "")
        XCTAssertEqual(object!.number, (record.objectForKey("number") as? NSNumber)!, "")
        
        XCTAssertTrue(record.objectForKey("name").isKindOfClass(NSString), "")
        XCTAssertEqual(object!.name, (record.objectForKey("name") as? NSString)!, "")
        
        XCTAssertTrue(record.objectForKey("date").isKindOfClass(NSDate), "")
        XCTAssertEqual(object!.date, (record.objectForKey("date") as? NSDate)!, "")
        
    }
}

class TestObject: NSObject {
    var number: NSNumber = 0.0
    var name: NSString = "TestObject"
    var date: NSDate = NSDate.new()
}
