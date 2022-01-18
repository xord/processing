// -*- mode: objc -*-
#import <Foundation/Foundation.h>


@interface RubySketch : NSObject

	+ (void) setup;

	+ (void) start: (NSString*) path;

	+ (void) setActiveReflexViewController: (id) reflexViewController;

	+ (void) resetActiveReflexViewController;

@end
