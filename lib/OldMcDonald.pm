package OldMcDonald;

use Moo;
use strict;
use warnings;

has song => (is => 'ro', default => sub {
    return [split /\n/, <<'SONG'];
Old McDonald has a farm, eieio.
And on that farm he has some cows, eieio.
With a moo-moo here, and a moo-moo there,
here a moo, there a moo, everywhere a moo-moo...
Old McDonald has a farm, eieio.
SONG
});

has num_lines    => (is => 'lazy');

has line_numbers => (is => 'lazy');

has title        => (
    is      => 'ro',
    default => sub {'Old McDonald'}
);

sub _build_num_lines    { return scalar @{shift->song} }

sub _build_line_numbers { return [keys @{shift->song}] }

sub line {
    my ($self, $line) = @_;

    die "$line is out of range (0..",
        $self->num_lines-1,
        ").\n"
      if $line < 0 || $line >= $self->num_lines;

    return $self->song->[$line];
}

1;
