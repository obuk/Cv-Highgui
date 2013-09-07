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
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Cv::Highgui', $VERSION);


=head1 DESCRIPTION

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
