//
//  MyDelegate.swift
//  IKAsyncable
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

public class MyDelegate: IKAsyncTableViewDelegate {
    override public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? MyCell {
            let randomDelay = Double(arc4random_uniform(5) + 1)
            cell.setup(randomDelay)
        }
        
        super.tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    }
}
