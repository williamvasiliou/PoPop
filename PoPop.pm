package PoPop;

use strict;
use warnings;

use Math::Trig qw(tanh);

sub new {
	my @C = split(' ', shift);
	my %V = map { $_ => 1 } @C;
	my @V = sort keys %V;

	my %Wf = map { $_ => { map { $_ => 0 } @V } } @V;
	my %Wi = map { $_ => { map { $_ => 0 } @V } } @V;
	my %Wo = map { $_ => { map { $_ => 0 } @V } } @V;
	my %Wc = map { $_ => { map { $_ => 0 } @V } } @V;

	my %Uf = map { $_ => { map { $_ => 0 } @V } } @V;
	my %Ui = map { $_ => { map { $_ => 0 } @V } } @V;
	my %Uo = map { $_ => { map { $_ => 0 } @V } } @V;
	my %Uc = map { $_ => { map { $_ => 0 } @V } } @V;

	my @f = ({ map { $_ => 0 } @V });
	my @i = ({ map { $_ => 0 } @V });
	my @o = ({ map { $_ => 0 } @V });
	my @c = ({ map { $_ => 0 } @V }, { map { $_ => 0 } @V });
	my @h = ({ map { $_ => 0 } @V }, { map { $_ => 0 } @V });

	{
		C => \@C,
		V => \@V,
		Wf => \%Wf,
		Wi => \%Wi,
		Wo => \%Wo,
		Wc => \%Wc,
		Uf => \%Uf,
		Ui => \%Ui,
		Uo => \%Uo,
		Uc => \%Uc,
		f => \@f,
		i => \@i,
		o => \@o,
		c => \@c,
		h => \@h,
	}
}

sub sigmoid {
	return 1 / (1 + 2.718281828459045 ** (-shift));
}

sub f {
	my $x = shift;
	my $h = shift;

	my %w = map { $_ => $Wf{$x}{$_} } @V;
	foreach my $i (@V) {
		my $u = $Uf{$i};
		foreach (@V) {
			$w{$_} += $u->{$_} * $h->{$i};
		}
	}

	foreach (@V) {
		$w{$_} = sigmoid($w{$_});
	}

	return \%w;
}

sub i {
	my $x = shift;
	my $h = shift;

	my %w = map { $_ => $Wi{$x}{$_} } @V;
	foreach my $i (@V) {
		my $u = $Ui{$i};
		foreach (@V) {
			$w{$_} += $u->{$_} * $h->{$i};
		}
	}

	foreach (@V) {
		$w{$_} = sigmoid($w{$_});
	}

	return \%w;
}

sub o {
	my $x = shift;
	my $h = shift;

	my %w = map { $_ => $Wo{$x}{$_} } @V;
	foreach my $i (@V) {
		my $u = $Uo{$i};
		foreach (@V) {
			$w{$_} += $u->{$_} * $h->{$i};
		}
	}

	foreach (@V) {
		$w{$_} = sigmoid($w{$_});
	}

	return \%w;
}

sub ci {
	my $x = shift;
	my $h = shift;

	my %w = map { $_ => $Wc{$x}{$_} } @V;
	foreach my $i (@V) {
		my $u = $Uc{$i};
		foreach (@V) {
			$w{$_} += $u->{$_} * $h->{$i};
		}
	}

	foreach (@V) {
		$w{$_} = Math::Trig::tanh($w{$_});
	}

	return \%w;
}

sub c {
	my $f = shift;
	my $c = shift;
	my $i = shift;
	my $ci = shift;

	return { map { $_ => $f->{$_} * $c->{$_} + $i->{$_} * $ci->{$_} } @V };
}

sub h {
	my $o = shift;
	my $c = shift;

	return { map { $_ => $o->{$_} * sigmoid($c->{$_}) } @V };
}

sub y {
	my $x = shift;
	$h[0] = $h[1];
	$f[0] = f($x, $h[0]);
	$i[0] = i($x, $h[0]);
	$o[0] = o($x, $h[0]);
	$c[0] = $c[1];
	$c[1] = ci($x, $h[0]);
	$c[1] = c($f[0], $c[0], $i[0], $c[1]);
	$h[1] = h($o[0], $c[1]);

	my $h = $h[1]->{$V[0]};
	my $v = 0;

	foreach (my $i = 1; $i < @V; ++$i) {
		my $y = $h[1]->{$V[$i]};
		if ($y > $h) {
			$h = $y;
			$v = $i;
		}
	}

	return $V[$v];
}
