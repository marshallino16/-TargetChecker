//
//  ProjectHelper.m
//  🎯TargetsChecker
//
//  Created by Junior on 01/02/2017.
//  Copyright © 2017 Anthony Fernandez. All rights reserved.
//

#import "ProjectHelper.h"
#import "SynthesizeSingleton.h"




#pragma mark - Project Helper: Configuration

#define AVAILABLE_TYPE          @[ @"xib" , @"m" , @"storyboard" , @"swift" ]




#pragma mark - Project Helper: Private Interface

@interface ProjectHelper ()

@property (nonatomic, strong) NSDictionary *projectObjects;
@property (nonatomic, strong) NSArray *projectTargets;
@property (nonatomic, strong) NSDictionary *targetsBuildPhases;

@end



#pragma mark - Project Helper: Implementation

@implementation ProjectHelper

SYNTHESIZE_SINGLETON_FOR_CLASS(ProjectHelper, sharedHelper);



#pragma mark - Public API

- (void)loadProjectPropertiesWithProjectPath:(NSString *)projectPath {
    
    // Handle package content target
    NSAssert([projectPath hasSuffix:@"xcodeproj"], @"Wrong file targeted. I'll only eat a .xcodeproj file.");
    
    NSString *xCodeProjectPath = [projectPath stringByAppendingPathComponent:@"project.pbxproj"];
    NSDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:xCodeProjectPath];
    self.projectObjects = [plist objectForKey:@"objects"];
}

- (void)loadProjectTargetsWithTargets:(NSArray *)targets {
    NSMutableArray *availableTargets = [[NSMutableArray alloc] init];
    
    [self.projectObjects enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *obj, BOOL *stop) {
        NSString *objectType = [obj objectForKey:@"isa"];
        
        if ( [objectType isEqualToString:@"PBXNativeTarget"] ) {
            if ( [targets containsObject:[obj objectForKey:@"name"]] ) {
                [availableTargets addObject:obj];
                printf("✅ Target '%s' found in project.\n", [[NSString stringWithFormat:@"%@", [obj objectForKey:@"name"]] UTF8String] );
            }
        }
    }];
    
    self.projectTargets = availableTargets;
    
    [self loadTargetsBuildPhases];
}



#pragma amrk - Private methods

- (void)loadTargetsBuildPhases {
    NSMutableDictionary *availableBuildPhases = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *target in self.projectTargets) {
        
        printf("\n▶️ BuildPhases for target: %s\n", [[NSString stringWithFormat:@"%@", [target objectForKey:@"name"]] UTF8String] );
        
        NSArray *buildPhases = [target objectForKey:@"buildPhases"];
        for (int i = 0 ; i < buildPhases.count ; ++i) {
            printf("%s\n", [buildPhases[i] UTF8String]);
        }
        
        [availableBuildPhases setObject:buildPhases forKey:[target objectForKey:@"name"]];
    }
    
    self.targetsBuildPhases = availableBuildPhases;
    
    [self loadBuildPhasesFiles];
}

- (void)loadBuildPhasesFiles {
    
    
    // FILES
    // -----
    
    printf("\n");
    
    NSMutableArray *availableFilesPerTarget = [[NSMutableArray alloc] init];
    
    [self.targetsBuildPhases enumerateKeysAndObjectsUsingBlock:^(NSString *targetName, NSArray *buildPhases, BOOL * _Nonnull stop) {
        
        NSMutableArray *availableFiles = [[NSMutableArray alloc] init];
        
        [self.projectObjects enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *obj, BOOL *stop) {
            NSString *objectType = [obj objectForKey:@"isa"];
            
            if ( [objectType hasSuffix:@"BuildPhase"] && [buildPhases containsObject:key]) {
                
                if ( [obj objectForKey:@"files"] && ((NSArray *)[obj objectForKey:@"files"]).count > 0 ) {
                    
                    printf("BuildPhase: %s contains files section\n", [key UTF8String]);
                    
                    NSArray *fileArray = [obj objectForKey:@"files"];
                    
                    [self.projectObjects enumerateKeysAndObjectsUsingBlock:^(NSString *keyFile, NSDictionary *objFile, BOOL *stop) {
                        
                        NSString *objectFileType = [objFile objectForKey:@"isa"];
                        
                        if ( [objectFileType hasSuffix:@"BuildFile"] && [fileArray containsObject:keyFile]) {
                            
                            [availableFiles addObject:[objFile objectForKey:@"fileRef"]];
                        }
                        
                    }];
                    
                }
                

                
            }
        }];
        
        [availableFilesPerTarget addObject:@{targetName : availableFiles}];
        printf("%lu files for %s target\n", availableFiles.count, [targetName UTF8String]);
    }];

    
    // CHECK
    // -----
    
    printf("\n");
    
    for (int i = 0 ; i < availableFilesPerTarget.count ; ++i) {
        
        if (i > 0) {
            
            [((NSDictionary *)availableFilesPerTarget[i-1]) enumerateKeysAndObjectsUsingBlock:^(NSString *keyPrevious, NSArray *objPrevious, BOOL * _Nonnull stop) {
                
                NSLog(@"Obj %lu", objPrevious.count);
                
                [((NSDictionary *)availableFilesPerTarget[i]) enumerateKeysAndObjectsUsingBlock:^(NSString *keyCurrent, NSArray *objCurrent, BOOL * _Nonnull stop) {
                    
                    NSLog(@"Obj %lu", objCurrent.count);
                    
                    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:objPrevious];
                    [intermediate removeObjectsInArray:objCurrent];
                    NSUInteger difference = [intermediate count];
                    
                    printf("%lu missing files for target %s\n", difference, [keyCurrent UTF8String]);
                    
                    for (NSString *file in intermediate) {
                        
                        [self loadFileNameWithReference:file];
                    }
                    
                    NSMutableArray *intermediate2 = [NSMutableArray arrayWithArray:objCurrent];
                    [intermediate2 removeObjectsInArray:objPrevious];
                    NSUInteger difference2 = [intermediate2 count];
                    
                    printf("%lu missing files for target %s\n", difference2, [keyPrevious UTF8String]);
                    
                    for (NSString *file in intermediate2) {
                        
                        [self loadFileNameWithReference:file];
                    }
                }];
                
            }];
            
        }
        
    }
}

- (void)loadFileNameWithReference:(NSString *)reference {
    
    [self.projectObjects enumerateKeysAndObjectsUsingBlock:^(NSString *keyFile, NSDictionary *objFile, BOOL *stop) {
        
        NSString *objectFileType = [objFile objectForKey:@"isa"];
        
        if ( [objectFileType isEqualToString:@"PBXFileReference"] && [reference isEqualToString:keyFile]) {
            
            printf("%s\n", [[objFile objectForKey:@"path"] UTF8String]);
        }
    }];
}

@end
