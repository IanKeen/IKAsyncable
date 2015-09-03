//
//  IKAsyncOperationManagerTests.swift
//  IKAsyncable
//
//  Created by Ryan Arana on 9/1/15.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit
import XCTest

class IKAsyncOperationManagerTests: XCTestCase {

    var mgr = IKAsyncOperationManager()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mgr = IKAsyncOperationManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddOperationIfNeeded_whenGivenANewIndexPath_shouldAddTheOperationToTheCache() {
        // given
        let closure: IKAsyncOperationClosure = { success, failure in }
        let path = NSIndexPath(forItem: 0, inSection: 0)
        
        // sanity check
        XCTAssertEqual(mgr.operations.count, 0, "There should be nothing in the cache to start with")
        
        // when
        let added = mgr.addOperationIfNeeded(path, operation: closure)
        
        // then
        XCTAssertEqual(mgr.operations.count, 1, "There should be 1 operation in the cache after add the operation")
    }

    func testResetOperations_shouldRemoveAllOperations() {
        // given
        let closure: IKAsyncOperationClosure = { success, failure in }
        mgr.addOperationIfNeeded(NSIndexPath(forItem: 0, inSection: 0), operation: closure)
        
        // sanity check
        XCTAssertEqual(mgr.operations.count, 1, "There should be 1 operation in the cache after adding 1")
        
        // when
        mgr.resetOperations()
        
        // then
        XCTAssertEqual(mgr.operations.count, 0, "There should be no operations in the cache after resetting them")
    }
}
