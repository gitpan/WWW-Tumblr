#!/usr/bin/perl

package WWW::Tumblr;

use strict;
use warnings;

use Carp;
use Data::Dumper;
use LWP::UserAgent;

our $VERSION = '0';

my $ua = LWP::UserAgent->new;

sub new {
	my($class, %opts) = shift;
	
	return bless {
		user		=>	$opts{user},
		email		=>	$opts{email},
		password	=>	$opts{password},
	}, $class;
}

sub email {
	my($self, $email) = @_;
	
	if(defined $email) {
		$self->{email} = $email;
	}
	
	$self->{email};
}

sub password {
	my($self, $password) = @_;
	
	$self->{password} = $password if defined $password;
	
	$self->{password};
}

sub user {
	my($self, $user) = @_;
	
	$self->{user} = $user if defined $user;
	$self->{user};
}

sub read_json {
	my($self, %opts) = @_;
	$opts{json} = 1;
	return $self->read(%opts);
}

sub read {
	my($self, %opts) = @_;
	
	croak "No user was defined" unless defined $self->{user};
	
	my $url = qq{http://$self->{user}.tumblr.com/api/read};
	$url .= '/json' if defined $opts{json};
	
	$url .= '?'.join'&',map{qq{$_=$opts{$_}}} sort keys %opts;
	
	my $response = $ua->get($url);
	return $response->content;	
	
}

sub write {
	my($self, %opts) = @_;
}

1;