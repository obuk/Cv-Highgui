# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 2;
use Test::LeakTrace;
BEGIN { use_ok('Cv') }
BEGIN { use_ok('Cv::Highgui', qw(:all)) }

SKIP: {
	skip('no DISPLAY', 1) unless Cv->hasGUI;
	my $win = 'Cv';
	ok(!Cv->GetWindowHandle($win));
	namedWindow($win, 0);
	ok(Cv->GetWindowHandle($win));
	resizeWindow($win, 320, 240);
	Cv->waitKey(500);
	resizeWindow($win, 160, 120);
	Cv->waitKey(500);
	destroyWindow($win);
	ok(!Cv->GetWindowHandle($win));
}

SKIP: {
	skip('no DISPLAY', 1) unless Cv->hasGUI;
	my $win = 'Cv';
	ok(!Cv->GetWindowHandle($win));
	namedWindow($win);
	ok(Cv->GetWindowHandle($win));
	moveWindow($win, 100, 100);
	Cv->waitKey(500);
	moveWindow($win, 200, 200);
	Cv->waitKey(500);
	destroyAllWindows();
	ok(!Cv->GetWindowHandle($win));
}

SKIP: {
	skip('no DISPLAY', 1) unless Cv->hasGUI;

no_leaks_ok {
	my $win = 'Cv';
	namedWindow($win, 0);
	resizeWindow($win, 320, 240);
	Cv->waitKey(500);
	resizeWindow($win, 160, 120);
	Cv->waitKey(500);
	destroyWindow($win);
};

no_leaks_ok {
	my $win = 'Cv';
	namedWindow($win);
	moveWindow($win, 100, 100);
	Cv->waitKey(500);
	moveWindow($win, 200, 200);
	Cv->waitKey(500);
	destroyAllWindows();
};

}
