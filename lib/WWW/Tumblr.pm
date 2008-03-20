#!/usr/bin/perl

package WWW::Tumblr;

use strict;
use warnings;

use Carp;
use Data::Dumper;
use LWP::UserAgent;

our $VERSION = '1';

sub new {
	my($class, %opts) = shift;

	my $ua = LWP::UserAgent->new;
	
	return bless {
		user		=> $opts{user},
		email		=> $opts{email},
		password	=> $opts{password},
		url			=> $opts{url},
		ua 			=>	$ua,
	}, $class;
}

sub email {
	my($self, $email) = @_;
	$self->{email} = $email if $email;
	$self->{email};
}

sub password {
	my($self, $password) = @_;
	$self->{password} = $password if $password;
	$self->{password};
}

sub user {
	my($self, $user) = @_;
	$self->{user} = $user if $user;
	$self->{user};
}

sub url {
	my($self, $url) = @_;
	
	if($url) {
		$self->{url} = $url;
		$self->{url} =~ s/\/\z//;
	} else {
		$self->{url} = 'http://' . $self->user . '.tumblr.com'
			if $self->user;
	}
	
	return $self->{url};
}

sub read_json {
	my($self, %opts) = @_;
	$opts{json} = 1;
	return $self->read(%opts);
}

sub read {
	my($self, %opts) = @_;
	
	croak "No user or url defined" unless $self->user or $self->url;

	my $url = $self->url . '/api/read';
	
	$url .= '/json' if defined $opts{json};
	
	$url .= '?'.join'&',map{qq{$_=$opts{$_}}} sort keys %opts;
	
	return $self->{ua}->get($url)->content;

}

sub write {
	my($self, %opts) = @_;

	croak "No email was defined" unless $self->email;
	croak "No password was defined" unless $self->password;
	croak "No type defined for writing" unless $opts{type};
	
	$opts{'email'} = $self->email;
	$opts{'password'} = $self->password;
	
	my $req = HTTP::Request->new(POST => 'http://www.tumblr.com/api/write');
	$req->content_type('application/x-www-form-urlencoded');
	$req->content(join '&', map{ qq{$_=$opts{$_}} } sort keys %opts);
	
	my $res = $self->{ua}->request($req);
	
	if($res->is_success) {
		return $res->decoded_content;
	} else {
		$self->errstr($res->as_string);
		return;
	}
	
}

sub errstr {
	my($self, $err) = @_;
	$self->{errstr} = $err if $err;
	$self->{errstr};
}

1;