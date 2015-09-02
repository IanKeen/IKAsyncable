//
//  IKAsyncOperation.swift
//  IKAsyncable
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import Foundation

public final class IKAsyncOperation {
    //MARK : - Public Properties
    let operation: IKAsyncOperationClosure
    let indexPath: NSIndexPath
    
    private(set) var state: IKAsyncOperationState? {
        didSet(newValue) {
            self.dispatchStateOnMainThread()
        }
    }
    
    //MARK : - Private Properties
    private var failureCount: Int = 0
    private let stateChange: IKAsyncStateChange
    
    //MARK : - Lifecycle
    init(indexPath: NSIndexPath, operation: IKAsyncOperationClosure, stateChange: IKAsyncStateChange) {
        self.indexPath = indexPath
        self.stateChange = stateChange
        self.operation = operation
        self.dispatchStateOnMainThread()
    }
    
    //MARK : - Public Functions
    public func performOperation(maxFailures: Int) {
        if let state = self.state {
            self.dispatchStateOnMainThread()
            
        } else {
            self.executeOperation(maxFailures)
        }
    }
    
    //MARK : - Private Functions
    private func executeOperation(maxFailures: Int) {
        self.state = .InProgress
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.operation(
                success: { result in
                    self.state = .Complete(result)
                    
                }, failure: { error in
                    self.failureCount++
                    if (maxFailures != IKAsyncOperationManager.UnlimitedRetries &&
                        self.failureCount >= maxFailures) {
                            self.state = .Failed(error)
                    } else {
                        self.executeOperation(maxFailures)
                    }
                }
            )
        }
    }
    private func dispatchStateOnMainThread() {
        if (NSThread.currentThread().isMainThread) {
            self.stateChange(self)
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.stateChange(self)
            }
        }
    }
}