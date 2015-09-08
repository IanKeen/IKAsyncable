//
//  IKAsyncable.swift
//  IKAsyncable
//
//  Created by Ian Keen on 27/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

public typealias IKAsyncSuccess = (Any) -> Void
public typealias IKAsyncFailure = (NSError) -> Void
public typealias IKAsyncOperationClosure = (success: IKAsyncSuccess, failure: IKAsyncFailure) -> Void
public typealias IKAsyncStateChange = (IKAsyncOperation) -> Void

public protocol IKAsyncableManager {
    func resetOperation(asyncable: IKAsyncable)
}

public protocol IKAsyncable {
    func ikAsyncOperation() -> IKAsyncOperationClosure
    func ikAsyncOperationState(manager: IKAsyncableManager, state: IKAsyncOperationState)
}
