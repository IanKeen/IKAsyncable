//
//  MyCell.swift
//  IKAsyncTableViewDelegate_temp
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

class MyCell : UITableViewCell, IKAsyncable {
    private var randomDelay: Double!
    func setup(randomDelay: Double) {
        self.randomDelay = randomDelay
    }
    
    func ikAsyncOperation() -> IKAsyncOperationClosure {
        return { success, failure in
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(self.randomDelay * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                if (self.randomDelay > 3) {
                    failure(NSError(domain: "domain", code: 0, userInfo: [NSLocalizedDescriptionKey: "ERROR"]))
                } else {
                    success("Yay!!")
                }
            }
        }
    }
    func ikAsyncOperationState(state: IKAsyncOperationState) {
        let color: UIColor
        switch state {
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
