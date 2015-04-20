//
//	UITableView+NSFetchedResultsController.h
//	Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 26.9.13.
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface UITableView (NSFetchedResultsController)

@property (nonatomic, strong) NSMutableIndexSet *deletedSectionIndexes;
@property (nonatomic, strong) NSMutableIndexSet *insertedSectionIndexes;
@property (nonatomic, strong) NSMutableArray *deletedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedRowIndexPaths;

- (void)addChangeForSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void)addChangeForObjectAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)commitChanges;
- (void)clearChanges;

@end
