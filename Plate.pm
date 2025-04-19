package Plate;

use strict;
use warnings;

sub new {
	my @C = split(//, shift);
	my $N = int shift;
	my $V = @C % 2 ? [
		(@C >> 1) * (((@C ** $N) - 1) / (@C - 1)),
	] : [
		(@C >> 1) * (@C ** ($N - 1)),
	];

	push(@$V, -$$V[0]);
	{
		C => \@C,
		M => (@C ** $N) - 1,
		N => $N,
		V => $V,
	}
}

sub index {
	my ($C, $substr) = @_;
	my $index = index($C, $substr);

	die "$index < 0\n" if ($index < 0);
	return $index;
}

1;
