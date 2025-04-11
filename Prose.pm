#!/usr/bin/env perl
package Prose;

use strict;
use warnings;

sub new {
	my $N = int shift;

	{
		C => {},
		M => 2 * $N - 1,
		N => $N,
		V => {},
	}
}

sub update {
	my $C = shift;
	my @C = split(//, shift);

	my %V = map { $_ => 1 } @C;
	my @V = sort keys %V;

	my $M = $$C{M};
	my $N = $$C{N};
	foreach my $w (@V) {
		for (my $i = 0; $i < @C; ++$i) {
			if ($C[$i] eq $w) {
				my @N = ();

				for (my $j = $N; $j > 0; --$j) {
					my $k = $i - $j;

					if ($k >= 0) {
						push(@N, $C[$k]);
					} else {
						push(@N, '');
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

				++$C->{V}{$w};
				my $C = $$C{C};
				$$C{$w} = {} unless (exists($$C{$w}));
				$C = $$C{$w};

				for (my $i = 0; $i < $M; ++$i) {
					my $k = $N[$i];

					$$C{$k} = {} unless (exists($$C{$k}));
					$C = $$C{$k};
				}
				++$$C{$N[$M]};
			}
		}
	}
}

sub N {
	my $C = shift;
	my @C = ();

	foreach (sort keys %$C) {
		my $N = $$C{$_};

		if (ref $N) {
			push(@C, @{N($N)});
		} else {
			push(@C, \$$C{$_});
		}
	}

	return \@C;
}

sub V {
	my $C = shift;
	my @C = ();

	if (ref $C) {
		foreach my $N (sort keys %$C) {
			push(@C, {
				C => [
					$N,
					@{$$_{C}},
				],
				N => $$_{N},
			}) foreach (@{V($$C{$N})});
		}
	} else {
		push(@C, {
			C => [],
			N => $C,
		});
	}

	return \@C;
}

sub divide {
	my $C = shift;
	my @V = sort keys %{$$C{V}};

	my $N = 0;
	if (@_) {
		foreach (@V) {
			my @V = @{N $C->{C}{$_}};

			$N += $$_ foreach (@V);
			for (my $i = 1; $i < @V; ++$i) {
				${$V[$i]} += ${$V[$i - 1]}
			}
			$$_ /= $N foreach (@V);

			$N = 0;
		}
	}

	$N += $C->{V}{$_} foreach (@V);
	for (my $i = 1; $i < @V; ++$i) {
		$C->{V}{$V[$i]} += $C->{V}{$V[$i - 1]};
	}
	$C->{V}{$_} /= $N foreach (@V);
}

sub pick {
	my $C = shift;
	my $N = shift;

	foreach (@$N) {
		if (exists($$C{$_})) {
			$C = $$C{$_};
		} else {
			return [];
		}
	}
	my @V = @{V($C)};

	$N = 0;
	$N += $$_{N} foreach (@V);
	for (my $i = 1; $i < @V; ++$i) {
		${$V[$i]}{N} += ${$V[$i - 1]}{N};
	}
	$$_{N} /= $N foreach (@V);

	my $r = rand;
	foreach (@V) {
		return $$_{C} if ($r < $$_{N});
	}

	return [];
}

sub prose {
	my $C = shift;
	my @C = ();

	my %V = %{$$C{V}};
	my @V = sort keys %V;

	my $M = int shift;
	my $N = $$C{N};
	my $r = rand;
	foreach (@V) {
		if ($r < $V{$_}) {
			push(@C, $_);
			last;
		}
	}

	for (my $i = 0; $i < $M; ++$i) {
		my @N = ();
		for (my $j = $N + 1; $j > 1; --$j) {
			my $k = @C - $j;

			if ($k >= 0) {
				push(@N, $C[$k]);
			} else {
				push(@N, '');
			}
		}

		my $N = pick($C->{C}{$C[$i]}, \@N);
		if (@$N) {
			push(@C, @$N);
		} else {
			my $r = rand;
			foreach (@V) {
				if ($r < $V{$_}) {
					push(@C, $_);
					last;
				}
			}
		}
	}

	return join('', @C);
}

1;
