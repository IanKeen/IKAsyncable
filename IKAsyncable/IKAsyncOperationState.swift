//
//  IKAsyncOperationState.swift
//  IKAsyncable
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import Foundation

public enum IKAsyncOperationState : CustomStringConvertible {
    case InProgress
    case Complete(Any)
    case Failed(NSError)
    
    public var description: String {
        switch self {
        case .InProgress: return "In Progress"
        case .Complete(let value): return "Complete: \(value)"
        case .Failed(let error): return "Failure: \(error)"
        }
    }
}