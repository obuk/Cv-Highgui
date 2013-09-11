# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

=encoding utf8

=head1 NAME

Cv::Highgui - Cv extension for OpenCV High-level GUI and Media I/O (highgui)

=head1 SYNOPSIS

  use Cv::Highgui;

=cut

package Cv::Highgui;

use 5.008;
use strict;
use warnings;
use Carp;
use Cv ();

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	createTrackbar
	getTrackbarPos
	imshow
	namedWindow
	destroyWindow
	destroyAllWindows
	moveWindow
	resizeWindow
	setMouseCallback
	setTrackbarPos
	waitKey
	VideoCapture
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Cv::Highgui', $VERSION);


=head1 DESCRIPTION

=head2 User Interface

=over

=item 
L<createTrackbar()|http://docs.opencv.org/search.html?q=createTrackbar>

  createTrackbar($trackbarname, $winname, $value, $count, \&onChange);
  createTrackbar($trackbarname, $winname, $value, $count, \&onChange, $userdata);
  createTrackbar($trackbarname, $winname, my $value, $count);

=item
L<getTrackbarPos()|http://docs.opencv.org/search.html?q=getTrackbarPos>

  my $pos = getTrackbarPos($trackbarname, $winname);

=cut

sub getTrackbarPos { goto &Cv::cvGetTrackbarPos }

=item
L<imshow()|http://docs.opencv.org/search.html?q=imshow>

  imshow($winname, $mat);

=cut

sub imshow { goto &Cv::cvShowImage }

=item
L<namedWindow()|http://docs.opencv.org/search.html?q=namedWindow>

  namedWindow($winname, $flags = CV_WINDOW_AUTOSIZE);

=cut

sub namedWindow { goto &Cv::cvNamedWindow }

=item
L<destroyWindow()|http://docs.opencv.org/search.html?q=destroyWindow>

  destroyWindow($winname);

=cut

sub destroyWindow { goto &Cv::cvDestroyWindow }

=item
L<destroyAllWindows()|http://docs.opencv.org/search.html?q=destroyAllWindows>

  destroyAllWindows();

=cut

sub destroyAllWindows { goto &Cv::cvDestroyAllWindows }

=item
L<moveWindow()|http://docs.opencv.org/search.html?q=moveWindow>

  moveWindow($name, $x, $y);

=cut

sub moveWindow { goto &Cv::cvMoveWindow }

=item
L<resizeWindow()|http://docs.opencv.org/search.html?q=resizeWindow>

  resizeWindow($winname, $width, $height);

=cut

sub resizeWindow { goto &Cv::cvResizeWindow }

=item
L<setMouseCallback()|http://docs.opencv.org/search.html?q=setMouseCallback>

  setMouseCallback($winname, \&onMouse, $userdata = 0);

=cut

sub setMouseCallback { goto &Cv::cvSetMouseCallback }

=item
L<setTrackbarPos()|http://docs.opencv.org/search.html?q=setTrackbarPos>

  setTrackbarPos($trackbarName, $windowName, $pos);

=cut

sub setTrackbarPos { goto &Cv::cvSetTrackbarPos }

=item
L<waitKey()|http://docs.opencv.org/search.html?q=waitKey>

  waitKey($delay = 0);

=cut

sub waitKey { goto &Cv::cvWaitKey }

=back

=head2 Reading and Writing Images and Video

=over

=item
L<imdecode()|http://docs.opencv.org/search.html?q=imdecode>

=cut

sub imdecode { goto &Cv::cvDecodeImageM }

=item
L<imencode()|http://docs.opencv.org/search.html?q=imencode>

=cut

sub imencode { ($_[0], $_[1]) = ($_[1], $_[0]); goto &Cv::Arr::cvEncodeImageM }

=item
L<imread()|http://docs.opencv.org/search.html?q=imread>

=cut

sub imread { goto &Cv::cvLoadImageM }

=item
L<imwrite()|http://docs.opencv.org/search.html?q=imwrite>

=cut

sub imwrite { goto &Cv::cvSaveImage }

=item
L<VideoCapture()|http://docs.opencv.org/search.html?q=VideoCapture>

    VideoCapture
    VideoCapture::VideoCapture
    VideoCapture::open
    VideoCapture::isOpened
    VideoCapture::release
    VideoCapture::grab
    VideoCapture::retrieve
    VideoCapture::read
    VideoCapture::get
    VideoCapture::set

=cut

{
	package Cv::Highgui::VideoCapture;
	sub new {
		my $class = shift;
		my $self = bless { };
		$self->open(@_) if @_;
		$self;
	}
	sub open {
		my $self = shift;
		unless ($self->{CvCapture}) {
			$self->{CvCapture} = $_[0] =~ m{^(/dev/video)?\d+$}?
				Cv::cvCaptureFromCAM(@_) : Cv::cvCaptureFromFile(@_);
		}
		$self->isOpened;
	}
	sub isOpened { shift->{CvCapture} }
	sub release { shift->{CvCapture} = undef }
	sub grab {
		unshift(@_, shift->{CvCapture});
		goto &Cv::Capture::cvGrabFrame
	}
	sub retrieve {
		unshift(@_, shift->{CvCapture});
		goto &Cv::Capture::cvRetrieveFrame
	}
	sub query {
		unshift(@_, shift->{CvCapture});
		goto &Cv::Capture::cvQueryFrame
	}
	sub get {
		unshift(@_, shift->{CvCapture});
		goto &Cv::Capture::cvGetCaptureProperty
	}
	sub set {
		unshift(@_, shift->{CvCapture});
		goto &Cv::Capture::cvSetCaptureProperty
	}
}


sub VideoCapture {
	Cv::Highgui::VideoCapture->new(@_);
}


=item
L<VideoWriter()|http://docs.opencv.org/search.html?q=VideoWriter>

    VideoWriter
    VideoWriter::VideoWriter
    # ReleaseVideoWriter
    VideoWriter::open
    VideoWriter::isOpened
    VideoWriter::write

=cut

{
	package Cv::Highgui::VideoWriter;
	sub new {
		my $class = shift;
		my $self = bless { };
		$self->open(@_) if @_;
		$self;
	}
	sub open {
		my $self = shift;
		unless ($self->{CvVideoWriter}) {
			$self->{CvVideoWriter} = Cv::cvCreateVideoWriter(@_);
		}
		$self->isOpened;
	}
	sub isOpened { shift->{CvVideoWriter} }
	sub release { shift->{CvVideoWriter} = undef }
	sub write {
		unshift(@_, shift->{CvVideoWriter});
		goto &Cv::cvWriteFrame
	}
}


sub VideoWriter {
	Cv::Highgui::VideoWriter->new(@_);
}

=back

=cut


1;
__END__

=head2 EXPORT

None by default.

=head1 SEE ALSO

L<Cv>

=head1 AUTHOR

Koichi Kubo, E<lt>obuk@obuk.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Koichi Kubo

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut
