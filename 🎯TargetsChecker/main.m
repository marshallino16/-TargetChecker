//
//  main.m
//  🎯TargetsChecker
//
//  Created by Junior on 01/02/2017.
//  Copyright © 2017 Anthony Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandLineHelper.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // Load input
        [[CommandLineHelper sharedHelper] loadArguments];
    }
    return 0;
}
