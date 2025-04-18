package Plate;

use strict;
use warnings;

sub new {
	my @C = split(//, shift);

	return \@C;
}

sub index {
	my ($C, $substr) = @_;
	my $index = index($C, $substr);

	die "$index < 0\n" if ($index < 0);
	return $index;
}

1;
