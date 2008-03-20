#!/usr/bin/perl

use strict;
use warnings;

use WWW::Tumblr;

my $tumblr = WWW::Tumblr->new;

$tumblr->email('my@email.com');
$tumblr->password('h4x0r');

$tumblr->write(type => 'regular', body => 'WWW::Tumblr test.')
	or die $tumblr->errstr;