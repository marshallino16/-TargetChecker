//
//  CommandLineHelper.h
//  🎯TargetsChecker
//
//  Created by Junior on 01/02/2017.
//  Copyright © 2017 Anthony Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark - Command Line Helper: Public Interface

@interface CommandLineHelper : NSObject

// Life cycle
+ (CommandLineHelper *)sharedHelper;

// Public API
- (void)loadArguments;

@end
