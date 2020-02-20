package db::bidang;
use strict;
use warnings;
use parent 'base4db';

sub list {
	my $self = shift;
	my $param = shift;

	my %search;
	$search{nama} = {like => $param->('nama').'%'} if $param->('nama');

	my $page = $param->('_pg') || 1;
	my $per_page = $param->('_per') || 10;
	my $bidang = $self->table('bidang')->rows_per_page($per_page)->page($page)->search(\%search)->order_by('id');
	return $bidang;
}

sub data {
	my $self = shift;
	my $id_bidang = shift;

	my $bidang;
	if($id_bidang){
		$bidang = $self->table('bidang')->search({id => $id_bidang})->single;
	}else{
		$bidang = $self->table('bidang')->order_by('id');
	}

	return $bidang;
}

sub data_array {
	my $self = shift;
	my $id_bidang = shift;

	my @bidang_id = split /,/, $id_bidang;
	my %search;
	$search{id} = [@bidang_id];
	my $bidang = $self->table('bidang')->search(\%search)->order_by('id');

	return $bidang;
}

1;
