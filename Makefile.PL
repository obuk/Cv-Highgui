# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use 5.008008;
use ExtUtils::MakeMaker;

our %CONFIGURE_REQUIRES = (
	'ExtUtils::ParseXS'   => '2.220',
	'ExtUtils::PkgConfig' => '1.120',
	'Cv' => '0.32',
	'Data::Structure::Util' => '0.15',
	$^O eq 'cygwin' ? ('ExtUtils::MM_Cygwin' => '6.620') : (),
);

our %TEST_REQUIRES = (
	'Test::Number::Delta' => '1.030',
	'Test::Exception'     => '0.310',
	'Test::LeakTrace'     => '0.140',
	);

our %PREREQ_PM = ( %CONFIGURE_REQUIRES );

use Cv::Config;

my $cf = new Cv::Config;

WriteMakefile(
	NAME => "Cv::Highgui",
	VERSION_FROM => "lib/Cv/Highgui.pm",
	ABSTRACT_FROM => "lib/Cv/Highgui.pm",
	AUTHOR => 'KUBO, Koichi <k@obuk.org>',
	CONFIGURE_REQUIRES => \%CONFIGURE_REQUIRES,
	TEST_REQUIRES => \%TEST_REQUIRES,
	PREREQ_PM => \%PREREQ_PM,
	%Cv::Config::MM,
	INC => '-I.',
	XSOPT => '-C++ -hiertype',
	clean => {
		FILES => [ '*.tmp', '_Inline', 'cover_db', ]
	},
);

sub MY::postamble {
	"

cover:
	cover -delete
	-HARNESS_PERL_SWITCHES=-MDevel::Cover make test
	cover
	find cover_db -type d |xargs chmod +rx

";
}
