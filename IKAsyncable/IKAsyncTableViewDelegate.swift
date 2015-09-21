//
//  IKAsyncTableViewDelegate.swift
//  IKAsyncable
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

public class IKAsyncTableViewDelegate : IKAsyncOperationManager, IKAsyncableManager, UITableViewDelegate {
    //MARK : - Private Properties
    private weak var tableView: UITableView?
    
    //MARK : - Public Functions
    public func resetOperation(asyncable: IKAsyncable) {
        if
            let asyncable = asyncable as? UITableViewCell,
            let tableView = self.tableView,
            let indexPath = tableView.indexPathForCell(asyncable) {
                self.operations.removeValueForKey(indexPath)
                
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    self.handleCell(cell, indexPath: indexPath)
                }
        }
    }
    override public func resetOperations() {
        super.resetOperations()
        
        if let tableView = self.tableView,
            let indexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths  {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    self.handleCell(cell, indexPath: indexPath)
                }
            }
        }
    }
    public func resetOperation(indexPath: NSIndexPath) {
        self.operations.removeValueForKey(indexPath)
        
        if let tableView = self.tableView {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                self.handleCell(cell, indexPath: indexPath)
            }
        }
    }
    
    //MARK : - UITableViewDelegate
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView = tableView
        self.stateChange = self.operationStateChanged
        
        self.handleCell(cell, indexPath: indexPath)
    }
    
    //MARK: - Private Functions
    private func handleCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        if let cell = cell as? IKAsyncable {
            let operation = self.addOperationIfNeeded(indexPath, operation: cell.ikAsyncOperation())
            self.handleAsyncableState(indexPath)
            self.dispatchState(operation, asyncable: cell)
        }
    }
    private func operationStateChanged(operation: IKAsyncOperation) {
        let indexPath = NSIndexPath(forRow: operation.indexPath.row, inSection: operation.indexPath.section)
        
        if
            let tableView = self.tableView,
            let cell = tableView.cellForRowAtIndexPath(indexPath),
            let asyncable = cell as? IKAsyncable {
                self.dispatchState(operation, asyncable: asyncable)
        }
    }
    private func dispatchState(operation: IKAsyncOperation, asyncable: IKAsyncable) {
        if let state = operation.state {
            asyncable.ikAsyncOperationState(self, state: state)
        }
    }
}

