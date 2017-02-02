//
//  SynthesizeSingleton.h
//  🎯TargetsChecker
//
//  Created by Junior on 01/02/2017.
//  Copyright © 2017 Anthony Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>



#define SYNTHESIZE_SINGLETON_FOR_CLASS(className,singletonName)     \
\
static className *singletonName = nil;                              \
\
+ (className *)singletonName {                                      \
static dispatch_once_t done;										\
dispatch_once(&done, ^{ 											\
singletonName = [[className alloc] init];                           \
});																	\
return singletonName; 												\
} 																	\
\
+ (id)allocWithZone:(NSZone *)zone { 								\
static dispatch_once_t done;										\
dispatch_once(&done, ^{ 											\
singletonName = [super allocWithZone:zone];							\
});																	\
return singletonName; 												\
} 																	\
\
- (id)copyWithZone:(NSZone *)zone { 								\
return self; 														\
} 																	\
\
