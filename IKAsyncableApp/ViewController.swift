//
//  ViewController.swift
//  IKAsyncTableViewDelegate_temp
//
//  Created by Ian Keen on 27/08/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var dataSource: MyDataSource!
    @IBOutlet private var delegate: MyDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(MyCell.self, forCellReuseIdentifier: "cell")
    }
}
