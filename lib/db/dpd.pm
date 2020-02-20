package db::dpd;
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
	my $dpd = $self->table('dpd')->rows_per_page($per_page)->page($page)->search(\%search)->order_by('id');
	return $dpd;
}

sub data {
	my $self = shift;
	my $id_dpd = shift;

	my $dpd;
	if($id_dpd){
		$dpd = $self->table('dpd')->search({id => $id_dpd})->single;
	}else{
		$dpd = $self->table('dpd')->order_by('id');
	}

	return $dpd;
}

sub list_kecamatan {
	my $self = shift;
	my $param = shift;

	my %search;
	$search{nama} = {like => $param->('nama').'%'} if $param->('nama');
	$search{dpd} = $param->('dpd') if $param->('dpd');

	my $page = $param->('_pg') || 1;
	my $per_page = $param->('_per') || 10;
	my $kecamatan = $self->table('kecamatan')->rows_per_page($per_page)->page($page)->search(\%search)->order_by('id');
	return $kecamatan;
}

sub kecamatan {
	my $self = shift;
	my $id_kecamatan = shift;
	my $id_dpd = shift;
	my $kode_kecamatan = shift;

	my $kecamatan;
	if($kode_kecamatan){
		$kecamatan = $self->table('kecamatan')->search({kode => $kode_kecamatan})->single;
	}elsif($id_dpd){
		$kecamatan = $self->table('kecamatan')->search({dpd => $id_dpd});
	}elsif($id_kecamatan){
		$kecamatan = $self->table('kecamatan')->search({id => $id_kecamatan})->single;
	}else{
		$kecamatan = $self->table('kecamatan');
	}

	return $kecamatan;
}

sub kecamatan_array {
	my $self = shift;
	my $id_kecamatan = shift;

	my @kecamatan_id = split /,/, $id_kecamatan;
	my %search;
	$search{id} = [@kecamatan_id];
	my $kecamatan = $self->table('kecamatan')->search(\%search)->order_by('id');

	return $kecamatan;
}

sub list_kelurahan {
	my $self = shift;
	my $param = shift;

	my %search;
	$search{nama} = {like => $param->('nama').'%'} if $param->('nama');
	$search{kecamatan} = $param->('kecamatan') if $param->('kecamatan');
	$search{'kecamatan.dpd'} = $param->('dpd') if $param->('dpd');

	my $page = $param->('_pg') || 1;
	my $per_page = $param->('_per') || 10;
	my $kelurahan = $self->table('kelurahan')
			->inner_join('kecamatan', {kecamatan => 'id'})
			->select_also('kecamatan.dpd')
			->rows_per_page($per_page)->page($page)->search(\%search)->order_by('me.id');
	return $kelurahan;
}

sub kelurahan {
	my $self = shift;
	my $id_kelurahan = shift;
	my $id_kecamatan = shift;
	my $kode_kelurahan = shift;

	my @array_kecamatan = split/\,/, $id_kecamatan;

	my $kelurahan;
	if($kode_kelurahan){
		$kelurahan = $self->table('kelurahan')->search({kode => $kode_kelurahan})->single;
	}elsif($id_kecamatan){
		$kelurahan = $self->table('kelurahan')->search({kecamatan => {"in", [@array_kecamatan]}});
	}elsif($id_kelurahan){
		$kelurahan = $self->table('kelurahan')->search({id => $id_kelurahan})->single;
	}else{
		$kelurahan = $self->table('kelurahan');
	}

	return $kelurahan;
}

sub kelurahan_array {
	my $self = shift;
	my $id_kelurahan = shift;

	my @kelurahan_id = split /,/, $id_kelurahan;
	my %search;
	$search{id} = [@kelurahan_id];
	my $kelurahan = $self->table('kelurahan')->search(\%search)->order_by('id');

	return $kelurahan;
}

1;
