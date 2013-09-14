# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 2;
use Test::LeakTrace;
BEGIN { use_ok('Cv') }
BEGIN { use_ok('Cv::Highgui', qw(:all)) }

# ============================================================
#  User Interface
# ============================================================

{
	no warnings;
	no strict 'refs';
	local *Cv::cvGetTrackbarPos = sub {
		is(scalar @_, 2);
		my ($trackbar_name, $window_name) = @_;
		is($trackbar_name, 'trackbarname');
		is($window_name,'winname');
	};
	getTrackbarPos('trackbarname', 'winname');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvShowImage = sub {
		is(scalar @_, 2);
		my ($name, $image) = @_;
		is($name, 'winname');
		is($image, 'mat');
	};
	imshow('winname', 'mat');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvNamedWindow = sub {
		is(scalar @_, 2);
		my ($name, $flags) = @_;
		is($name, 'winname');
		is($flags, 'flags');
	};
	namedWindow('winname', 'flags');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvDestroyWindow = sub {
		is(scalar @_, 1);
		my ($name) = @_;
		is($name, 'winname');
	};
	destroyWindow('winname');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvDestroyAllWindows = sub {
		is(scalar @_, 0);
	};
	destroyAllWindows();
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvMoveWindow = sub {
		is(scalar @_, 3);
		my ($name, $x, $y) = @_;
		is($name, 'winname');
		is($x, 'x');
		is($y, 'y');
	};
	moveWindow('winname', 'x', 'y');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvResizeWindow = sub {
		is(scalar @_, 3);
		my ($name, $width, $height) = @_;
		is($name, 'winname');
		is($width, 'width');
		is($height, 'height');
	};
	resizeWindow('winname', 'width', 'height');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvSetMouseCallback = sub {
		is(scalar @_, 3);
		my ($window_name, $on_mouse, $param) = @_;
		is($window_name, 'winname');
		is($on_mouse, 'onMouse');
		is($param, 'userdata');
	};
	setMouseCallback('winname', 'onMouse', 'userdata');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvSetTrackbarPos = sub {
		is(scalar @_, 3);
		my ($trackbar_name, $window_name, $pos) = @_;
		is($trackbar_name, 'trackbarname');
		is($window_name, 'winname');
		is($pos, 'pos');
	};
	setTrackbarPos('trackbarname', 'winname', 'pos');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvWaitKey = sub {
		is(scalar @_, 1);
		my ($delay) = @_;
		is($delay, 'delay');
	};
	waitKey('delay');
}

# ============================================================
#  Reading and Writing Images and Video
# ============================================================

{
	no warnings;
	no strict 'refs';
	local *Cv::cvDecodeImageM = sub {
		is(scalar @_, 2);
		my ($buf, $iscolor) = @_;
		is($buf, 'buf');
		is($iscolor, 'flags');
	};
	imdecode('buf', 'flags');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::Arr::cvEncodeImage = sub {
		is(scalar @_, 3);
		my ($arr, $ext, $params) = @_;
		is($ext, 'ext');
		is($arr, 'img');
		is($params, 'params');
		'buf';
	};
	imencode('ext', 'img', my $buf, 'params');
	is($buf, 'buf');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvLoadImageM = sub {
		is(scalar @_, 2);
		my ($filename, $iscolor) = @_;
		is($filename, 'filename');
		is($iscolor, 'flags');
	};
	imread('filename', 'flags');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvSaveImage = sub {
		is(scalar @_, 3);
		my ($filename, $image, $params) = @_;
		is($filename, 'filename');
		is($image, 'img');
		is($params, 'params');
	};
	imwrite('filename', 'img', 'params');
}

{
	no warnings;
	no strict 'refs';
	local *Cv::cvCaptureFromCAM = sub {
		is(scalar @_, 1);
		my ($device) = @_;
		like($device, qr/^\d+$/);
		'cvCaptureFromCAM';
	};
	local *Cv::cvCaptureFromFile = sub {
		is(scalar @_, 1);
		my ($filename) = @_;
		is($filename, 'filename');
		'cvCaptureFromFile';
	};
	isa_ok(VideoCapture(0), 'Cv::Highgui::VideoCapture');
	isa_ok(VideoCapture('filename'), 'Cv::Highgui::VideoCapture');
	my $capture = VideoCapture(1);
	ok($capture->isOpened);
	local *Cv::Capture::cvGrabFrame = sub {
		is(scalar @_, 1);
		my ($capture) = @_;
		is($capture, 'cvCaptureFromCAM');
		'cvGrabFrame';
	};
	is($capture->grab, 'cvGrabFrame');
	local *Cv::Capture::cvRetrieveFrame = sub {
		is(scalar @_, 1);
		my ($capture) = @_;
		is($capture, 'cvCaptureFromCAM');
		'cvRetrieveFrame';
	};
	is($capture->retrieve, 'cvRetrieveFrame');
	local *Cv::Capture::cvQueryFrame = sub {
		is(scalar @_, 1);
		my ($capture) = @_;
		is($capture, 'cvCaptureFromCAM');
		'cvQueryFrame';
	};
	is($capture->read, 'cvQueryFrame');
	local *Cv::Capture::cvGetCaptureProperty = sub {
		is(scalar @_, 2);
		my ($capture, $property_id) = @_;
		is($capture, 'cvCaptureFromCAM');
		is($property_id, 'prop_id');
		'cvGetCaptureProperty';
	};
	is($capture->get('prop_id'), 'cvGetCaptureProperty');
	local *Cv::Capture::cvSetCaptureProperty = sub {
		is(scalar @_, 3);
		my ($capture, $property_id, $value) = @_;
		is($capture, 'cvCaptureFromCAM');
		is($property_id, 'prop_id');
		is($value, 'value');
		'cvSetCaptureProperty';
	};
	is($capture->set('prop_id', 'value'), 'cvSetCaptureProperty');
	$capture->release;
	ok(!$capture->isOpened);
}


{
	no warnings;
	no strict 'refs';
	local *Cv::cvCreateVideoWriter = sub {
		is(scalar @_, 5);
		my ($filename, $fourcc, $fps, $frame_size, $is_color) = @_;
		is($filename, 'filename');
		is($fourcc, 'fourcc');
		is($fps, 'fps');
		is($frame_size, 'frame_size');
		is($is_color, 'is_color');
		'cvCreateVideoWriter';
	};
	my $writer = VideoWriter('filename', 'fourcc', 'fps', 'frame_size', 'is_color');
	isa_ok($writer, 'Cv::Highgui::VideoWriter');
	ok($writer->isOpened);
	local *Cv::VideoWriter::cvWriteFrame = sub {
		is(scalar @_, 2);
		my ($writer, $image) = @_;
		is($writer, 'cvCreateVideoWriter');
		is($image, 'image');
		'cvWriteFrame';
	};
	is($writer->write('image'), 'cvWriteFrame');
	$writer->release;
	ok(!$writer->isOpened);
}
