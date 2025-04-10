#!/usr/bin/env perl
use strict;
use warnings;

my @C = split(//, $C);
my %C = ();

my %V = map { $_ => 1 } @C;
my @V = sort map { $_ } keys %V;

my $N = 2;
my %N = ();
foreach my $w (@V) {
	for (my $i = 0; $i < @C; ++$i) {
		if ($C[$i] eq $w) {
			my @N = ();

			for (my $j = 1; $j <= $N; ++$j) {
				my $k = $i - $j;

				if ($k >= 0) {
					unshift(@N, $C[$k]);
				} else {
					unshift(@N, '');
				}
			}

			for (my $j = 1; $j <= $N; ++$j) {
				my $k = $i + $j;

				if ($k < @C) {
					push(@N, $C[$k]);
				} else {
					push(@N, '');
				}
			}

			my $C = \%C;
			for (my $i = 0; $i < $N; ++$i) {
				my $k = $N[$i];

				$$C{$k} = {} unless (exists($$C{$k}));
				$C = $$C{$k};
			}

			for (my $i = 1; $i < $N; ++$i) {
				my $k = $N[$i];

				$$C{$k} = {} unless (exists($$C{$k}));
				$C = $$C{$k};
			}

			++$$C{$N[2 * $N - 1]};
			++$N{$w};
		}
	}
}

my %W = (comments => 1, likes => 1, reactions => 1, views => 1);

sub value {
	my $p = shift;
	$$p{value} = 0;
	$$p{value} += $W{$_} * ($$p{$_} // 0) foreach (keys %W);
}
