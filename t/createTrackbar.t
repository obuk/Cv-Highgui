# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 2;
use Test::LeakTrace;
BEGIN { use_ok('Cv') }
BEGIN { use_ok('Cv::Highgui', qw(:all)) }

SKIP: {
	skip('require DISPLAY', 1) unless Cv->hasGUI;
	my ($win, $bar) = ('win', 'bar');
	my $image = Cv::Image->new([240, 320], CV_8UC3)->zero;
	Cv->NamedWindow($win);
	our @got; our $changed;
	sub onChange { @got = @_; $changed++ };
	is($Cv::TRACKBAR{$win}, undef);
	createTrackbar($bar, $win, my $val = 10, 100, \&onChange, my $data = rand);
	$image->ShowImage($win);
	Cv->WaitKey(1000);
	is(scalar @{$Cv::TRACKBAR{$win}}, 1);
	Cv->SetTrackbarPos($bar, $win, $val);
	is($got[0], undef);
	is($got[1], undef);
	ok(!$changed);
	my $expect = $val + 50;
	Cv->SetTrackbarPos($bar, $win, $expect);
	is($got[0], $expect);
	is($got[1], $data);
	is($val, $expect);
	ok($changed);
	Cv->WaitKey(1000);
	Cv->DestroyWindow($win);
	is($Cv::TRACKBAR{$win}, undef);
}

SKIP: {
	skip('require DISPLAY', 1) unless Cv->hasGUI;

no_leaks_ok {
	my $image = Cv::Image->new([240, 320], CV_8UC3)->zero;
	my $win = 'win';
	Cv->NamedWindow($win);
	createTrackbar('bar1', $win, my $val1 = 10, 100, sub {}, []);
	createTrackbar('bar2', $win, my $val2 = 20, 100, sub {});
	createTrackbar('bar3', $win, my $val3 = 30, 100);
	$image->ShowImage($win);
	Cv->SetTrackbarPos('bar1', $win, 50);
	Cv->SetTrackbarPos('bar2', $win, 50);
	Cv->SetTrackbarPos('bar3', $win, 50);
	Cv->WaitKey(1000);
	Cv->DestroyWindow($win);
};

}
