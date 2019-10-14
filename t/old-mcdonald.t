#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Mojo;
use Mojo::File qw(path);

use FindBin qw($Bin);
use lib "$Bin/../lib";

BEGIN { $ENV{'OLD_MCDONALD_DELAY_TIME'} = 0.0; }

my $t = Test::Mojo->new(
    Mojo::File->new(path(__FILE__)->dirname->sibling('old-mcdonald'))
);


$t->get_ok('/song-map')->status_is(200)
    ->json_like('/title' => qr{/title/$}, 'title link')
    ->json_has('/lines', 'lines field')
    ->json_like('/lines/0', qr{/line/1$}, 'first line')
    ->json_like('/lines/4', qr{/line/5$}, 'last line')
    ->json_hasnt('/lines/5', 'nonexistent line')
    ->json_is('/n_lines', 5, 'n_lines');

$t->get_ok('/title')->status_is(200)
    ->json_is('/title', 'Old McDonald', 'Title found');

$t->get_ok('/line/0')->status_is(404);

$t->get_ok('/line/1')->status_is(200)
    ->json_is('/line', 'Old McDonald has a farm, eieio.', 'First line')
    ->json_like('/next', qr{/line/2$}, 'next field');

$t->get_ok('/line/4')->status_is(200)
    ->json_is('/line', 'here a moo, there a moo, everywhere a moo-moo...', 'fourth line');

$t->get_ok('/line/5')->status_is(200)
    ->json_is('/line', 'Old McDonald has a farm, eieio.', 'Last line')
    ->json_is('/next', '', 'No next line');

$t->get_ok('/foo')->status_is(404)
    ->json_is('/status', 'error', 'error reported')
    ->json_is('/error', 'Not Found', 'Not found message')
    ->json_like('/resource', qr{/foo$}, 'Resource echoed');

done_testing();
