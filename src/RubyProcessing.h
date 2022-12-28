// -*- mode: objc -*-
#import <Foundation/Foundation.h>


@interface RubyProcessing : NSObject

	+ (void) setup;

	+ (void) start: (NSString*) path;

	+ (void) setActiveReflexViewController: (id) reflexViewController;

	+ (void) resetActiveReflexViewController;

@end
