//
//  IKAsyncCollectionViewDelegate.swift
//  IKAsyncable
//
//  Created by Ian Keen on 1/09/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

import UIKit

@availability(iOS, introduced=8.0)
public class IKAsyncCollectionViewDelegate : IKAsyncOperationManager, IKAsyncableManager, UICollectionViewDelegate {
    //MARK : - Private Properties
    private weak var collectionView: UICollectionView?
    
    //MARK : - Public Functions
    public func resetOperation(asyncable: IKAsyncable) {
        if
            let asyncable = asyncable as? UICollectionViewCell,
            let collectionView = self.collectionView,
            let indexPath = collectionView.indexPathForCell(asyncable) {
                self.operations.removeValueForKey(indexPath)
                
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                    self.handleCell(cell, indexPath: indexPath)
                }
        }
    }
    override public func resetOperations() {
        super.resetOperations()
        
        if let collectionView = self.collectionView,
            let indexPaths = collectionView.indexPathsForVisibleItems() as? [NSIndexPath] {
                for indexPath in indexPaths  {
                    if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                        self.handleCell(cell, indexPath: indexPath)
                    }
                }
        }
    }
    public func resetOperation(indexPath: NSIndexPath) {
        self.operations.removeValueForKey(indexPath)
        
        if let collectionView = self.collectionView {
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                self.handleCell(cell, indexPath: indexPath)
            }
        }
    }
    
    //MARK : - UICollectionViewDelegate
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView = collectionView
        self.stateChange = self.operationStateChanged
        
        self.handleCell(cell, indexPath: indexPath)
    }
    
    //MARK: - Private Functions
    private func handleCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        if let cell = cell as? IKAsyncable {
            let operation = self.addOperationIfNeeded(indexPath, operation: cell.ikAsyncOperation())
            self.handleAsyncableState(indexPath)
            self.dispatchState(operation, asyncable: cell)
        }
    }
    private func operationStateChanged(operation: IKAsyncOperation) {
        let indexPath = NSIndexPath(forRow: operation.indexPath.row, inSection: operation.indexPath.section)
        
        if
            let collectionView = self.collectionView,
            let cell = collectionView.cellForItemAtIndexPath(indexPath),
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

