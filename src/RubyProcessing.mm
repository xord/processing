#import <CRuby.h>
#import "RubyProcessing.h"
#include "../src/ios/view_controller.h"


static ReflexViewController* active_reflex_view_controller = nil;

static ReflexViewController*
ReflexViewController_create()
{
	return active_reflex_view_controller;
}

static void
ReflexViewController_show (UIViewController*, ReflexViewController*)
{
}


@implementation RubyProcessing

	+ (void) setup
	{
		static BOOL done = NO;
		if (done) return;
		done = YES;

		[CRuby addLibrary:@"RubyProcessing" bundle:[NSBundle bundleForClass:RubyProcessing.class]];

		ReflexViewController_set_create_fun(ReflexViewController_create);
		ReflexViewController_set_show_fun(ReflexViewController_show);
	}

	+ (void) start: (NSString*) path
	{
		[CRuby evaluate:[NSString stringWithFormat:@
			"raise 'already started' unless require 'processing/include'\n"
			"load '%@'\n"
			"PROCESSING_WINDOW.__send__ :end_draw\n"
			"PROCESSING_WINDOW.show",
			path
		]];
	}

	+ (void) setActiveReflexViewController: (id) reflexViewController
	{
		active_reflex_view_controller = reflexViewController;
	}

	+ (void) resetActiveReflexViewController
	{
		active_reflex_view_controller = nil;
	}

@end
