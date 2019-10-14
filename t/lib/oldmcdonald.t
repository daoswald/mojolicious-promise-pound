#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../../lib";

use Test::More;

use_ok 'OldMcDonald';
can_ok 'OldMcDonald' => qw(song num_lines line_numbers title line);

my @text = split /\n/, <<'SONG';
Old McDonald has a farm, eieio.
And on that farm he has some cows, eieio.
With a moo-moo here, and a moo-moo there,
here a moo, there a moo, everywhere a moo-moo...
Old McDonald has a farm, eieio.
SONG

my $song = new_ok 'OldMcDonald';

is $song->num_lines, scalar(@text), 'Correct number of lines.';

is $song->title, 'Old McDonald', 'Got correct song name.';

for (0..$#text) {
    is ($song->line($_), $text[$_], "Line $_ is correct.");
}

is_deeply $song->line_numbers, [keys @text], 'Got correct line number list.';

is_deeply $song->song, \@text, 'Song is correct.';

done_testing();
