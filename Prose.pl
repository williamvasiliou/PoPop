#!/usr/bin/env perl
use warnings;
use strict;

my %W = (comments => 1, likes => 1, reactions => 1, views => 1);

sub value {
	my $p = shift;
	my $value = 0;

	foreach (keys %W) {
		$value += $W{$_} * %$p{$_};
	}

	return $value;
}
