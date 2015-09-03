# IKAsyncable
An (almost) drop in UITableViewDelegate & UICollectionViewDelegate for better async cell operations

## Why?
This is the basically the result of my blog post on how to properly 
handle async tasks in table views: 
[Make your UIViewController Awesynchronous!](http://blog.ios-developers.io/make-your-uiviewcontroller-awesynchronous/).

## How to use
Getting up and running is a peice of cake... No matter if you are working with a new or existing codebase!
If you currently don't use a delegate in your `UITableView` or `UICollectionView` 
you can simply hook up an instance of `IKAsyncTableViewDelegate` or `IKAsyncCollectionViewDelegate`

otherwise...

### UITableViewDelegate

* Make your existing `UITableViewDelegate` inherit from `IKAsyncTableViewDelegate`
* If you are using the `willDisplayCell` method you just need to mark it `overrides` and call the super method

### UITableViewCell

* Have your cell conform to the `IKAsyncable` protocol
* Implement `func ikAsyncOperation() -> IKAsyncOperationClosure` and place all your async operations here.
This will allow the code to stay with the cell, but it will be executed outside the lifecycle of the cell. 
The code is automatically executed on a background thread so you don't need to do any GCD wrapping.
The sucessful result or error from failure will be cached for the next time the cell needs it.

```swift
func ikAsyncOperation() -> IKAsyncOperationClosure {
    return { success, failure in
        /*
        perform async code here
        and call success(result) or failure(error)
        depending on the outcome.
        */
    }
}
```

* Implement `func ikAsyncOperationState(state: IKAsyncOperationState)` to be notified when the state of the operation changes.
This will be called each time the state changes; if the cell is visible it will receive the change right away, 
otherwise it will get the state the next time the cell is visible. This is always delivered safely on the main thread.

```swift
func ikAsyncOperationState(state: IKAsyncOperationState) {
    let color: UIColor
    switch state {
    case .InProgress: color = .yellowColor()
    case .Complete(let result): color = .greenColor()
    case .Failed(let error): color = .redColor()
    }
    
    self.backgroundColor = color
    self.textLabel?.text = "\(state)"
}
```

### UICollectionViewDelegate

The setup for a UICollectionView is exactly the same :)

## Invalidating the Cache

If you implement a pull to refresh or you have some other 
reason for needing to reset the async operations you can call:

`delegate.resetOperations()` - This will reset all async operations causing them to start again
`delegate.resetOperation(cell)` - This will reset the operation for the passed item and cause it to start again

## Handling failure

You can configure `IKAsyncable` operations to retry a given number of times before reporting failure. 
This can be adjusted by setting the `delegate.maxNumberOfFailures` property (the default is 3).
If you want operations to retry indefinitely you can set `maxNumberOfFailures` to `IKAsyncOperationManager.UnlimitedRetries`

## The rest...

This is written for Swift 1.2

Check out the included app to see it in action; 
I've tried to make this simple to use and as easy to integrate into existing systems as I can.

Feel free to submit any feedback or pull requests!

