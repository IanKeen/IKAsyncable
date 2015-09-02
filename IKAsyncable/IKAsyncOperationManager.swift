//
//  IKAsyncOperationManager.swift
//  IKAsyncable
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import Foundation

public class IKAsyncOperationManager : NSObject {
    //MARK : - Constants
    public static let UnlimitedRetries = Int.max
    
    //MARK : - Internal Properties
    internal var operations = [NSIndexPath: IKAsyncOperation]()
    internal var stateChange: IKAsyncStateChange?
    
    //MARK : - Public Properties
    @IBInspectable public var maxNumberOfFailures: Int = 3
    
    //MARK : - Public Functions
    public func addOperationIfNeeded(indexPath: NSIndexPath, operation: IKAsyncOperationClosure) -> IKAsyncOperation {
        if let asyncOperation = self.operations[indexPath] {
            return asyncOperation
            
        } else {
            let newOperation = IKAsyncOperation(indexPath: indexPath, operation: operation) { op in
                self.stateChange?(op)
            }
            self.operations[indexPath] = newOperation
            return newOperation
        }
    }
    public func resetOperations() {
        self.operations.removeAll()
    }
    
    //MARK : - Internal - Operations
    internal func handleAsyncableState(indexPath: NSIndexPath) {
        if let operation = self.operations[indexPath] {
            operation.performOperation(self.maxNumberOfFailures)
        }
    }
}
