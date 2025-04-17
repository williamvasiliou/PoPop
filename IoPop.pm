package IoPop;

use strict;
use warnings;

use open ':encoding(UTF-8)';
my %W = (comments => 1, likes => 1, reactions => 1);
my @keys = sort keys %W;

sub post {
	open(my $fh, '<', @_ ? shift : 'IoPop.txt') or die "$!\n";

	my @post = ();
	while (<$fh>) {
		chomp;

		my $post = {
			text => [],
		};

		for (1 .. (int)) {
			chomp($_ = <$fh>);
			push(@{$$post{text}}, $_);
		}
		$$post{post} = join("\n", @{$$post{text}});

		$$post{$_} = int(<$fh>) foreach (@keys);
		$$post{value} = 0;
		$$post{value} += $W{$_} * ($$post{$_} // 0) foreach (keys %W);
		push(@post, $post);
	}

	close $fh;
	return \@post;
}

sub divide {
	my $post = shift;
	my @post = @$post;

	my $N = 0;
	$N += $$_{value} foreach (@post);
	for (my $i = 1; $i < @post; ++$i) {
		$post[$i]->{value} += $post[$i - 1]->{value};
	}
	$$_{value} /= $N foreach (@post);
}

sub submit {
	my $post = shift;
	my @post = @$post;

	open(my $fh, '>', @_ ? shift : 'IoPop.txt') or die "$!\n";
	local *STDOUT = $fh;

	foreach my $post (@post) {
		my @text = split("\n", $$post{post});
		print(scalar @text . "\n");
		print("$_\n") foreach (@text);
		print("$$post{$_}\n") foreach (@keys);
	}

	close $fh;
}

1;
