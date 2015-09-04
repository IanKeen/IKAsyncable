//
//  IKAsyncOperationTests.swift
//  IKAsyncable
//
//  Created by Ian Keen on 3/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit
import XCTest

class IKAsyncOperationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformOperation_whenClosureOperationIsSuccessful_shouldUpdateStateWithCompletion() {
        // given
        let expectation = self.expectationWithDescription("")
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let operation = IKAsyncOperation(
            indexPath: indexPath,
            operation: exampleSuccessfulOperation(0)) { op in
                if let state = op.state {
                    switch state {
                    case .Complete(let result):
                        if (result as! Bool) {
                            expectation.fulfill()
                        }
                    default: break;
                    }
                }
        }
        
        // when
        operation.performOperation(0)
        
        // then
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testPerformOperation_whenClosureOperationIsUnsuccessful_shouldUpdateStateWithFailure() {
        // given
        let expectation = self.expectationWithDescription("")
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let operation = IKAsyncOperation(
            indexPath: indexPath,
            operation: exampleUnsuccessfulOperation()) { op in
                if let state = op.state {
                    switch state {
                    case .Failed:
                        expectation.fulfill()
                    default: break;
                    }
                }
        }
        
        // when
        operation.performOperation(0)
        
        // then
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testPerformOperation_whenClosureOperationIsSuccessfulWithinMaxFailures_shouldUpdateStateWithCompletion() {
        // given
        let expectation = self.expectationWithDescription("")
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let operation = IKAsyncOperation(
            indexPath: indexPath,
            operation: exampleSuccessfulOperation(3)) { op in //fail 3 times, then succeed
                if let state = op.state {
                    switch state {
                    case .Complete(let result):
                        if (result as! Bool) {
                            expectation.fulfill()
                        }
                    default: break;
                    }
                }
        }
        
        // when
        operation.performOperation(4)
        
        // then
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testPerformOperation_whenClosureOperationIsUnsuccessfulWithinMaxFailures_shouldUpdateStateWithFailure() {
        // given
        let expectation = self.expectationWithDescription("")
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let operation = IKAsyncOperation(
            indexPath: indexPath,
            operation: exampleSuccessfulOperation(3)) { op in //fail 3 times, then succeed
                if let state = op.state {
                    switch state {
                    case .Failed:
                        expectation.fulfill()
                    default: break;
                    }
                }
        }
        
        // when
        operation.performOperation(2)
        
        // then
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testPerformOperation_whenClosureOperationIsUnsuccessfulAndMaxFailuresIsUnlimited_shouldNotUpdateStateWithCompletionOrFailure() {
        // given
        let expectation = self.expectationWithDescription("")
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let operation = IKAsyncOperation(
            indexPath: indexPath,
            operation: exampleUnsuccessfulOperation()) { op in
                if let state = op.state {
                    switch state {
                    case .InProgress: break;
                    default:
                        XCTFail("a state other than InProgress should never be sent")
                    }
                }
        }
        
        // when
        operation.performOperation(IKAsyncOperationManager.UnlimitedRetries)
        
        // then
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(9.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    //MARK : - Helpers
    func exampleSuccessfulOperation(failCount: Int) -> IKAsyncOperationClosure {
        var failures = 0
        
        return { success, failure in
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                failures++
                if (failures > failCount) {
                    success(true)
                } else {
                    failure(self.exampleError())
                }
            }
        }
    }
    func exampleUnsuccessfulOperation() -> IKAsyncOperationClosure {
        return { success, failure in
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                failure(self.exampleError())
            }
        }
    }
    func exampleError() -> NSError {
        let error = NSError(domain: "Domain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error"])
        return error
    }
}
