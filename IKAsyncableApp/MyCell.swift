//
//  MyCell.swift
//  IKAsyncTableViewDelegate_temp
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

class MyCell : UITableViewCell, IKAsyncable {
    func ikAsyncOperation() -> IKAsyncOperationClosure {
        return { success, failure in
            let randomDelay = Double(arc4random_uniform(5) + 1)
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(randomDelay * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                if (randomDelay > 3) {
                    failure(NSError(domain: "domain", code: 0, userInfo: [NSLocalizedDescriptionKey: "ERROR"]))
                } else {
                    success("blah blah")
                }
            }
        }
    }
    func ikAsyncOperationState(state: IKAsyncOperationState) {
        let color: UIColor
        switch state {
        case .Pending:
            color = .whiteColor()
        case .InProgress:
            color = .yellowColor()
        case .Complete(let result):
            color = .greenColor()
        case .Failed(_):
            color = .redColor()
        }
        
        self.backgroundColor = color
        self.textLabel?.text = "\(state)"
    }
}
