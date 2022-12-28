#import <CRuby.h>
#import "RubySketch.h"
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


@implementation RubySketch

	+ (void) setup
	{
		static BOOL done = NO;
		if (done) return;
		done = YES;

		[CRuby addLibrary:@"RubySketch" bundle:[NSBundle bundleForClass:RubySketch.class]];

		ReflexViewController_set_create_fun(ReflexViewController_create);
		ReflexViewController_set_show_fun(ReflexViewController_show);
	}

	+ (void) start: (NSString*) path
	{
		[CRuby evaluate:[NSString stringWithFormat:@
			"raise 'already started' unless require 'rubysketch-processing'\n"
			"load '%@'\n"
			"RUBYSKETCH_WINDOW.__send__ :end_draw\n"
			"RUBYSKETCH_WINDOW.show",
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
