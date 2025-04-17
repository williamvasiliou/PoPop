#!/usr/bin/env perl
use strict;
use warnings;

use IoPop;
use Prose;
use open ':encoding(UTF-8)';

if (@ARGV == 4) {
	my ($M, $N, $infile, $outfile) = @ARGV;
	my @post = @{&IoPop::post($infile)};
	IoPop::divide \@post;

	my $prose = Prose::new $N;
	Prose::update $prose, $$_{post} foreach (@post);
	Prose::divide $prose;

	my $r = rand;
	my @r = ();
	foreach (@post) {
		if ($r < $$_{value}) {
			@r = split(//, $$_{post});
			last;
		}
	}

	open(my $fh, '>', $outfile) or die "$!\n";
	print $fh (Prose::prose($prose, $M, \@r) . "\n");
	close $fh;
}
