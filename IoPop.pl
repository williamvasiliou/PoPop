#!/usr/bin/env perl
use strict;
use warnings;

use open ':encoding(UTF-8)';
my @keys = ('comments', 'likes', 'reactions');
my @post = ();

sub post {
	open(my $fh, '<', 'IoPop.txt') or die "$!\n";

	while (<$fh>) {
		chomp;

		my $post = {
			text => [],
		};

		for (1 .. (int)) {
			chomp($_ = <$fh>);
			push(@{$$post{text}}, $_);
		}

		$$post{$_} = int(<$fh>) foreach (@keys);
		push(@post, $post);
	}

	close $fh;
}

sub submit {
	open(my $fh, '>', 'IoPop.txt') or die "$!\n";
	local *STDOUT = $fh;

	foreach my $post (@post) {
		my @text = @{$$post{text}};
		print(scalar @text . "\n");
		print("$_\n") foreach (@text);
		print("$$post{$_}\n") foreach (@keys);
	}

	close $fh;
}
