#import <CRuby.h>
#import "RubySketch.h"


@implementation RubySketch

+ (void)initialize
{
	[CRuby addLibrary:@"RubySketch" bundle:[NSBundle bundleForClass:RubySketch.class]];
}

@end
