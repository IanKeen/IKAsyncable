//
//  IKAsyncOperationState.swift
//  IKAsyncable
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

public final class IKAsyncTableViewDelegate : IKAsyncOperationManager, UITableViewDelegate {
    //MARK : - Private Properties
    private weak var tableView: UITableView?
    
    //MARK : - Public Functions
    public func resetOperation(asyncable: IKAsyncable) {
        if
            let asyncable = asyncable as? UITableViewCell,
            let tableView = self.tableView,
            let indexPath = tableView.indexPathForCell(asyncable) {
                self.operations.removeValueForKey(indexPath)
        }
    }
    
    //MARK : - UITableViewDelegate
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView = tableView
        self.stateChange = self.operationStateChanged
        
        if let cell = cell as? IKAsyncable {
            let operation = self.addOperationIfNeeded(indexPath, operation: cell.ikAsyncOperation())
            self.handleAsyncableState(indexPath)
            self.dispatchState(operation, asyncable: cell)
        }
    }
    
    //MARK: - Private Functions
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
            asyncable.ikAsyncOperationState(state)
        }
    }
}

