#!/usr/bin/env perl

package Mojolicious::Command::pound;

use Mojo::Base qw(Mojolicious::Commands);
use Mojo::IOLoop;
use Mojo::Promise;
use Mojo::UserAgent;
use Mojo::Util qw(dumper getopt);
use Time::HiRes 'time';

has description => 'Perform HTTP GET requests -- a lot of them.';
has usage       => sub {shift->extract_usage};

sub run {
    my ($self, @args) = @_;

    my $ua = Mojo::UserAgent->new(ioloop => Mojo::IOLoop->singleton);

    my $parallel = 1;
    getopt \@args => 'p|parallel=i' => \$parallel;

    die $self->usage if $parallel < 1;
    die $self->usage unless my $url = shift @args;

    my $t0 = time;

    my @promises = map {$ua->get_p($url)} 1..$parallel;

    my $t1 = time;

    Mojo::Promise->all(@promises)->then(sub { say dumper($_->[0]->result->json) for @_ })->wait;

    my $t2 = time;

    say sprintf(
        "Ran %d requests\nGETs took %-0.3f seconds.\nResponses took %-0.3f seconds.\nElapsed time %-0.3f" =>
        $parallel, $t1-$t0, $t2-$t1, $t2-$t0
    );
}

1;
