//
//  MyDelegate.swift
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

public class MyDelegate: IKAsyncTableViewDelegate {
    var urls: [String]?
    
    override public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? MyCell, let url = self.urls?[indexPath.row] {
            cell.setup(url)
        }
        
        super.tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    }
}
