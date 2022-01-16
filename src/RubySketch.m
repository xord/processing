#import <CRuby.h>
#import "RubySketch.h"


@implementation RubySketch

+ (void)setup
{
	static BOOL done = NO;
	if (done) return;
	done = YES;

	[CRuby addLibrary:@"RubySketch" bundle:[NSBundle bundleForClass:RubySketch.class]];
}

@end
