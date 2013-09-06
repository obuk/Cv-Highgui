# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

=encoding utf8

=head1 NAME

Cv::Highgui - Cv extension for OpenCV High-level GUI and Media I/O (highgui)

=head1 SYNOPSIS

  use Cv::Highgui;
  blah blah blah

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
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Cv::Highgui', $VERSION);


=head1 DESCRIPTION

Stub documentation for Cv::Highgui, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 METHOD

=over

=item createTrackbar($barname, $winname, $value, $count, $onChange, $userdata)

 createTrackbar($barname, $winname, $value, $count, \&onChange);
 createTrackbar($barname, $winname, $value, $count, \&onChange, $userdata);
 createTrackbar($barname, $winname, my $value, $count);

=back

=cut

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head2 EXPORT

None by default.

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Koichi Kubo, E<lt>obuk@obuk.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Koichi Kubo

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
