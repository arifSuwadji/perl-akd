package base4db;
use strict;
use warnings;

sub new {
	my ($class, $dbix, $log) = @_;
	my $self = {dbix => $dbix, 'log' => $log};
	bless $self, $class;
	return $self;
}

sub table {
	my ($self, $name) = @_;
	return $self->{dbix}->table($name);
}

sub log {shift->{'log'}}

# method dbh bukan di dalam class/package db, karena:
# agar class2 lain yg di bawah namespace db, 
# juga bisa memakai dg cukup panggil method dbh.
# contoh: misal di dalam package/class db::program_perkuliahan, :
#	sub { my ($self...) = @_; ..... $self->dbh->begin(); ..... dsb.
sub dbh { shift->{dbix}->dbh() }


1;

