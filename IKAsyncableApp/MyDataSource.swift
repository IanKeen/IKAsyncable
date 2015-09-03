//
//  MyDataSource.swift
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

class MyDataSource: NSObject, UITableViewDataSource {
    var urls: [String]?
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.urls?.count ?? 0 }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! MyCell
    }
}
