# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
use Test::Exception;
BEGIN { use_ok('Cv') }
BEGIN { use_ok('Cv::Highgui', qw(:all)) }

sub usage {
	my ($p, $file, $line) = caller;
	local $_ = join('', @_);
	s/[()]/\\$&/g;
	s/\s*=\s*([^,\\]+)/\\s*=\\s*$1/g;
	s/,\s*/,\\s*/g;
	$_ = "Cv::(\\w+::)*$_" unless /^Cv::/;
	qr/[Uu]sage: $_ at $file line $line/;
}

throws_ok { createTrackbar() } usage('cvCreateTrackbar(trackbarName, windowName, value, count, onChange=NULL, userdata=NULL)');
throws_ok { createTrackbar('trackbarname') } usage('cvCreateTrackbar(trackbarName, windowName, value, count, onChange=NULL, userdata=NULL)');
throws_ok { createTrackbar('trackbarname', 'windowname') } usage('cvCreateTrackbar(trackbarName, windowName, value, count, onChange=NULL, userdata=NULL)');
throws_ok { createTrackbar('trackbarname', 'windowname', 0) } usage('cvCreateTrackbar(trackbarName, windowName, value, count, onChange=NULL, userdata=NULL)');
throws_ok { createTrackbar('trackbarname', 'windowname', 0, -1) } qr/OpenCV Error:/;


throws_ok { getTrackbarPos() } usage('cvGetTrackbarPos(trackbarName, windowName)');
throws_ok { setTrackbarPos() } usage('cvSetTrackbarPos(trackbarName, windowName, pos)');
