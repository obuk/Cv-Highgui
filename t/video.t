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

	Cv->namedWindow('Cv', 0);
	my $video = VideoCapture();

no_leaks_ok {
	skip('no camera', 1) unless $video->open(0);

	for (1 .. 30) {
		last unless my $frame = $video->read;
		imshow("Cv", $frame->flip(\0, 1));
		my $c = waitKey(33);
		last if $c >= 0 && ($c & 0377) == ord('q');
	}

};

}

