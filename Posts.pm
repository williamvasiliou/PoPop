package Posts;

use strict;
use warnings;

sub new {
	my $s = shift;
	my $post = 0;
	my @post = ();

	my $join = @_ ? shift : sub { join("\n", @{$_[0]}) };
	my $last = @_ ? shift : sub { 0 };

	my $profile = '';
	my $date = '';
	my $text = 0;
	for (my $i = 0; $i < @$s; ++$i) {
		$_ = $$s[$i];
		last if (&$last($i, $s));

		if (length > 17 and /^View profile for /s) {
			$profile = '';
			$_ = substr $_, 17;
			if ($_) {
				for (my $j = $i + 1; $j < @$s; ++$j) {
					if ($_ eq $$s[$j]) {
						$profile = $_;
						$date = '';
						$text = 0;
						$i = $j;
						last;
					}
				}

				next if $profile;
			}
			$_ = "View profile for $_";
		} elsif ($profile and not $date and /^[0-9]+[dmsy]( Edited)?$/s) {
			$$post{post} = &$join($$post{text}) if ($post);

			$date = $_;
			$post = {
				comments => 0,
				date => $date,
				likes => 0,
				profile => $profile,
				reactions => 0,
				text => [],
			};
			push(@post, $post);

			$text = $$post{text};
			next;
		} elsif ($post and /\|\|/s) {
			for (my $j = $i + 1; $j < @$s; ++$j) {
				$_ = $$s[$j];
				if (/\|\| ([0-9]+)$/s and $j < $#$s) {
					$_ = int($1);
					if ($$s[$j + 1] =~ /^Comments?$/s) {
						$$post{comments} += $_;
					} else {
						$$post{reactions} += $_;
					}
				} elsif (/^[0-9]+$/s) {
					$$post{reactions} += int;
				} elsif (/([0-9]+) Comments?$/s) {
					$$post{comments} += int($1);
				} elsif (/^Like$/s) {
					$profile = '';
					$date = '';
					$text = 0;
					$i = $j;
					last;
				}
			}
			next;
		}

		if ($text) {
			s/\s+/ /gs;
			s/\. ,/.,/gs;
			s/ 's/'s/gs;
			s/\* No alternative text description for this image//gs;
			push(@$text, $_);
		}
	}

	$$post{post} = &$join($$post{text}) if ($post);
	return \@post;
}

1;
