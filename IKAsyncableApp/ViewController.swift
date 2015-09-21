//
//  ViewController.swift
//
//  Created by Ian Keen on 27/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var dataSource: MyDataSource!
    @IBOutlet private var delegate: MyDelegate!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getPhotos { urls in
            self.dataSource.urls = urls
            self.delegate.urls = urls
            self.tableView.reloadData()
        }
    }
    
    let apiUrl = "http://jsonplaceholder.typicode.com/photos"
    private func getPhotos(result: [String] -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if
                let url  = NSURL(string: self.apiUrl),
                let data = NSData(contentsOfURL: url),
                let object = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray,
                let urls = object.valueForKeyPath("url") as? [String] {
                    dispatch_async(dispatch_get_main_queue()) {
                        result(urls)
                    }
            }
        }
    }
}
