# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 2;
use Test::LeakTrace;
BEGIN { use_ok('Cv') }
BEGIN { use_ok('Cv::Highgui', qw(createTrackbar)) }

SKIP: {
	skip('no DISPLAY', 1) unless Cv->hasGUI;
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
	is(Cv->GetTrackbarPos($bar, $win), $val);

	my $pos = 50;
	Cv->SetTrackbarPos($bar, $win, $pos);
	is($got[0], $pos);
	is($got[1], $data);
	is($val, $pos);
	ok($changed);
	is(Cv->GetTrackbarPos($bar, $win), $pos);

	@got = (); $changed = 0; $pos = 60;
	Cv->SetTrackbarPos($bar, $win, $pos);
	is($got[0], $pos);
	is($got[1], $data);
	is($val, $pos);
	ok($changed);
	is(Cv->GetTrackbarPos($bar, $win), $pos);

	Cv->WaitKey(1000);
	Cv->DestroyWindow($win);
	is($Cv::TRACKBAR{$win}, undef);
}

SKIP: {
	skip('no DISPLAY', 1) unless Cv->hasGUI;

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
	Cv->GetTrackbarPos('bar1', $win);
	Cv->GetTrackbarPos('bar2', $win);
	Cv->GetTrackbarPos('bar3', $win);
	Cv->WaitKey(1000);
	Cv->DestroyWindow($win);
};

}
