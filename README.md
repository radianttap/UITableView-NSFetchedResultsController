---
> Note: this is abandoned. 
> I don‘t recommend to use it in any new projects.
---

# `UITableView+NSFetchedResultsController`

This is an example of how to use the `UITableView` with `NSFetchedResultsController` with the least hassle. The code is based on the [investigation and hard work](http://www.fruitstandsoftware.com/blog/2013/02/19/uitableview-and-nsfetchedresultscontroller-updates-done-right/) of Michael Fey; you can also see this [gist](https://gist.github.com/MrRooni/4988922).

His code greatly improves the usual sample code you can find around, including in Apple's sample code. Since I much prefer to extract these away and no repeat them in each `UITableViewController` I do, I have created this category. Simply include it and write your `UITableView` delegate methods in the same way. 


## Setup

* [CocoaPods]  
  Add `pod 'UITableView+NSFetchedResultsController'` to your podfile.
* Manual  
  Copy `UITableView+NSFetchedResultsController.h/m` to your project.


## Usage

Just include the header and write your `NSFetchedResultsControllerDelegate` methods like this:

``` objective-c
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {

	[self.tableView addChangeForObjectAtIndexPath:indexPath
									forChangeType:type
									 newIndexPath:newIndexPath];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type {

	[self.tableView addChangeForSection:sectionInfo
								atIndex:sectionIndex
						  forChangeType:type];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	
	[self.tableView commitChanges];
}
```

# Credit

[Michael Fey](https://gist.github.com/MrRooni/4988922)

