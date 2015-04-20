//
//	UITableView+NSFetchedResultsController.m
//	Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 26.9.13.
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import "UITableView+NSFetchedResultsController.h"
#import <objc/runtime.h>


@implementation UITableView (NSFetchedResultsController)

- (void)addChangeForSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.insertedSectionIndexes addIndex:sectionIndex];
			break;

		case NSFetchedResultsChangeDelete: {
			[self.deletedSectionIndexes addIndex:sectionIndex];
			
			NSMutableArray *indexPathsInSection = [NSMutableArray array];
			for(NSIndexPath *indexPath in self.deletedRowIndexPaths)
			{
				if (indexPath.section == sectionIndex) {
					[indexPathsInSection addObject:indexPath];
				}
			}
			[self.deletedRowIndexPaths removeObjectsInArray:indexPathsInSection];
			break;
		}

		default:
			break;
	}
}

- (void)addChangeForObjectAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	if (type == NSFetchedResultsChangeInsert) {
		if ([self.insertedSectionIndexes containsIndex:newIndexPath.section]) {
			// If we've already been told that we're adding a section for this inserted row we skip it since it will handled by the section insertion.
			return;
		}
		[self.insertedRowIndexPaths addObject:newIndexPath];

	} else if (type == NSFetchedResultsChangeDelete) {
		if ([self.deletedSectionIndexes containsIndex:indexPath.section]) {
			// If we've already been told that we're deleting a section for this deleted row we skip it since it will handled by the section deletion.
			return;
		}
		[self.deletedRowIndexPaths addObject:indexPath];

	} else if (type == NSFetchedResultsChangeMove) {
		if ([self.insertedSectionIndexes containsIndex:newIndexPath.section] == NO) {
			[self.insertedRowIndexPaths addObject:newIndexPath];
		}
		if ([self.deletedSectionIndexes containsIndex:indexPath.section] == NO) {
			[self.deletedRowIndexPaths addObject:indexPath];
		}

	} else if (type == NSFetchedResultsChangeUpdate) {
		[self.updatedRowIndexPaths addObject:indexPath];
	}
}

/*
 
 NSFetchedResultsChangeInsert = 1,
 NSFetchedResultsChangeDelete = 2,
 NSFetchedResultsChangeMove = 3,
 NSFetchedResultsChangeUpdate = 4

 */

- (void)commitChanges {
	
	if (self.window == nil) {
		[self clearChanges];
		[self reloadData];
		return;
	}
	
	NSInteger totalChanges = [self.deletedSectionIndexes count] +
							[self.insertedSectionIndexes count] +
							[self.deletedRowIndexPaths count] +
							[self.insertedRowIndexPaths count] +
							[self.updatedRowIndexPaths count];

	if (totalChanges > 50) {
		[self clearChanges];
		[self reloadData];
		return;
	}

	[self beginUpdates];
	
	[self deleteSections:self.deletedSectionIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
	[self insertSections:self.insertedSectionIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
	
	[self deleteRowsAtIndexPaths:self.deletedRowIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
	[self insertRowsAtIndexPaths:self.insertedRowIndexPaths withRowAnimation:UITableViewRowAnimationRight];
	[self reloadRowsAtIndexPaths:self.updatedRowIndexPaths withRowAnimation:UITableViewRowAnimationNone];
	
	[self endUpdates];
	[self clearChanges];
}

- (void)clearChanges {

	self.insertedSectionIndexes = nil;
	self.deletedSectionIndexes = nil;
	self.deletedRowIndexPaths = nil;
	self.insertedRowIndexPaths = nil;
	self.updatedRowIndexPaths = nil;
}

#pragma mark - Overridden getters

/**
 * Lazily instantiate these collections.
 */

- (NSMutableIndexSet *)deletedSectionIndexes {

	NSMutableIndexSet *_deletedSectionIndexes = objc_getAssociatedObject(self, @selector(deletedSectionIndexes));
	if (_deletedSectionIndexes == nil) {
		_deletedSectionIndexes = [[NSMutableIndexSet alloc] init];
		objc_setAssociatedObject(self, @selector(deletedSectionIndexes), _deletedSectionIndexes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
 
	return _deletedSectionIndexes;
}

- (void)setDeletedSectionIndexes:(NSMutableIndexSet *)deletedSectionIndexes {
	
	objc_setAssociatedObject(self, @selector(deletedSectionIndexes), deletedSectionIndexes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableIndexSet *)insertedSectionIndexes {

	NSMutableIndexSet *_insertedSectionIndexes = objc_getAssociatedObject(self, @selector(insertedSectionIndexes));
	if (_insertedSectionIndexes == nil) {
		_insertedSectionIndexes = [[NSMutableIndexSet alloc] init];
		objc_setAssociatedObject(self, @selector(insertedSectionIndexes), _insertedSectionIndexes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	return _insertedSectionIndexes;
}

- (void)setInsertedSectionIndexes:(NSMutableIndexSet *)insertedSectionIndexes {
	
	objc_setAssociatedObject(self, @selector(insertedSectionIndexes), insertedSectionIndexes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)deletedRowIndexPaths {
 
	NSMutableArray *_deletedRowIndexPaths = objc_getAssociatedObject(self, @selector(deletedRowIndexPaths));
	if (_deletedRowIndexPaths == nil) {
		_deletedRowIndexPaths = [[NSMutableArray alloc] init];
		objc_setAssociatedObject(self, @selector(deletedRowIndexPaths), _deletedRowIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	return _deletedRowIndexPaths;
}

- (void)setDeletedRowIndexPaths:(NSMutableArray *)deletedRowIndexPaths {
	
	objc_setAssociatedObject(self, @selector(deletedRowIndexPaths), deletedRowIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)insertedRowIndexPaths {

	NSMutableArray *_insertedRowIndexPaths = objc_getAssociatedObject(self, @selector(insertedRowIndexPaths));
	if (_insertedRowIndexPaths == nil) {
		_insertedRowIndexPaths = [[NSMutableArray alloc] init];
		objc_setAssociatedObject(self, @selector(insertedRowIndexPaths), _insertedRowIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return _insertedRowIndexPaths;
}

- (void)setInsertedRowIndexPaths:(NSMutableArray *)insertedRowIndexPaths {
	
	objc_setAssociatedObject(self, @selector(insertedRowIndexPaths), insertedRowIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)updatedRowIndexPaths {

	NSMutableArray *_updatedRowIndexPaths = objc_getAssociatedObject(self, @selector(updatedRowIndexPaths));
	if (_updatedRowIndexPaths == nil) {
		_updatedRowIndexPaths = [[NSMutableArray alloc] init];
		objc_setAssociatedObject(self, @selector(updatedRowIndexPaths), _updatedRowIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return _updatedRowIndexPaths;
}

- (void)setUpdatedRowIndexPaths:(NSMutableArray *)updatedRowIndexPaths {
	
	objc_setAssociatedObject(self, @selector(updatedRowIndexPaths), updatedRowIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
