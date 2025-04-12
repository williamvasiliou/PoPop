package Links;

use strict;
use warnings;

use open ':encoding(UTF-8)';

sub s {
	my $s = 0;
	my @s = ();

	open(my $fh, '<', @_ ? shift : 'input.txt') or die "$!\n";
	while (<$fh>) {
		chomp;

		if ($s) {
			if (s/.*?\>//s) {
				s/\<https?:.*?\>//gs;
				$s = s/\<https?:.*$//s;
			} else {
				s/^.*$//s;
			}
		} else {
			s/\<https?:.*?\>//gs;
			$s = s/\<https?:.*$//s;
		}

		push(@s, $_);
	}
	close $fh;

	return \@s;
}

1;
