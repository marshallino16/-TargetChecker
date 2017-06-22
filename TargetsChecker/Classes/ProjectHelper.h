//
//  ProjectHelper.h
//  🎯TargetsChecker
//
//  Created by Junior on 01/02/2017.
//  Copyright © 2017 Anthony Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark - Project Helper: Public Interface

@interface ProjectHelper : NSObject

// Life cycle
+ (ProjectHelper *)sharedHelper;

// Public API
- (void)loadProjectPropertiesWithProjectPath:(NSString *)projectPath;
- (void)loadProjectTargetsWithTargets:(NSArray *)targets;

@end
