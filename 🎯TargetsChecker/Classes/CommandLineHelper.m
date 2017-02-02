//
//  CommandLineHelper.m
//  🎯TargetsChecker
//
//  Created by Junior on 01/02/2017.
//  Copyright © 2017 Anthony Fernandez. All rights reserved.
//

#import "CommandLineHelper.h"
#import "SynthesizeSingleton.h"
#import "ProjectHelper.h"




#pragma mark - Command Line Helper: Configuration

#define ARG_HELP                    @"help"
#define ARG_PROJECT                 @"project"
#define ARG_TARGETS                 @"targets"
#define ARG_EXCLUDE_FILE_TYPE       @"exclude"




#pragma mark - Command Line Helper: Private Interface

@interface CommandLineHelper ()

@end



#pragma mark - Command Line Helper: Implementation

@implementation CommandLineHelper

SYNTHESIZE_SINGLETON_FOR_CLASS(CommandLineHelper, sharedHelper);



#pragma mark - Public API

- (void)loadArguments {
    
    NSUserDefaults *argumentsDefaults = [NSUserDefaults standardUserDefaults];
    
    // HELP
    // ----
    
    if ([argumentsDefaults objectForKey:ARG_HELP]) {
        printf("# HELP requested \n");
        printf("%s \n\n", [self.showHelp UTF8String]);
    }
    
    // EXCLUDE
    // -------
    
    if ([argumentsDefaults objectForKey:ARG_EXCLUDE_FILE_TYPE]) {
        printf("\n# EXLUDE FILE TYPE requested: \n");
    }
    
    // PROJECT
    // -------
    
    if ([argumentsDefaults objectForKey:ARG_PROJECT]) {
        NSString *projectPath = [argumentsDefaults stringForKey:ARG_PROJECT];
        printf("\n# PROJECT requested: %s \n", [projectPath UTF8String]);
        
        [[ProjectHelper sharedHelper] loadProjectPropertiesWithProjectPath:projectPath];
    }
    
    // TARGETS
    // -------
    
    if ([argumentsDefaults objectForKey:ARG_TARGETS]) {
        NSString *targetsArgument = [argumentsDefaults objectForKey:ARG_TARGETS];
        NSArray *targets = [targetsArgument componentsSeparatedByString:@","];
        printf("\n# TARGETS requested: %s \n", [targetsArgument UTF8String]);
        
        [[ProjectHelper sharedHelper] loadProjectTargetsWithTargets:targets];
    }
    
}



#pragma mark - Private method

- (NSString *)showHelp {
    return nil;
}

@end
