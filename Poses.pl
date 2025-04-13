#!/usr/bin/env perl
use strict;
use warnings;

use IoPop;
use Links;
use Posts;

if (@ARGV == 4) {
	my ($dir, $epoch, $infile, $outfile) = @ARGV;
	my @post = @{&IoPop::post($infile)};
	opendir(my $dh, $dir);
	while (readdir $dh) {
		$_ = "$dir/$_";
		my $mtime = (stat $_)[9];
		if ($mtime >= $epoch) {
			my @s = map { s/^\s+|\s+$//gsr } @{&Links::s($_)};
			push(@post, @{&Posts::new(\@s)});
		}
	}
	closedir $dh;
	IoPop::submit(\@post, $outfile);
}
