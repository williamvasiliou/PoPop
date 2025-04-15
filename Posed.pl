#!/usr/bin/env perl
use strict;
use warnings;

use IoPop;
use Prose;
use open ':encoding(UTF-8)';

if (@ARGV == 4) {
	my ($M, $N, $infile, $outfile) = @ARGV;
	my @post = @{&IoPop::post($infile)};
	my $prose = Prose::new $N;
	Prose::update $prose, $$_{post} foreach (@post);
	Prose::divide $prose;

	open(my $fh, '>', $outfile) or die "$!\n";
	print $fh (Prose::prose($prose, $M) . "\n");
	close $fh;
}
