package db::kategori;
use strict;
use warnings;
use parent 'base4db';

sub list {
	my $self = shift;
	my $param = shift;

	my %search;
	$search{nama} = {like => $param->('nama').'%'} if $param->('nama');
	$search{id} = $param->('kategori') if $param->('kategori');
	$search{induk_id} = undef;

	my $page = $param->('_pg') || 1;
	my $per_page = $param->('_per') || 10;
	my $kategori = $self->table('kategori')->rows_per_page($per_page)->page($page)->search(\%search);
	return $kategori;
}

sub data {
	my $self = shift;
	my $id_kategori = shift;
	my $hitung_sub = shift;

	my $kategori;
	if($hitung_sub){
		$kategori = $self->table('kategori')->select('id', \'count(*)')->search({induk_id => $id_kategori});
	}elsif($id_kategori){
		$kategori = $self->table('kategori')->search({id => $id_kategori})->single;
	}else{
		$kategori = $self->table('kategori');
	}

	return $kategori;
}

sub induk {
	my $self = shift;
	my $induk_id = shift;

	my $induk;
	if($induk_id){
		$induk = $self->table('kategori')->search({induk_id => $induk_id});
	}else{
		$induk = $self->table('kategori')->search({induk_id => undef});
	}

	return $induk;
}

sub sub_induk {
	my $self = shift;

	my $sub_induk = $self->table('kategori')->search({induk_id => {'>', 0}});

	return $sub_induk;
}

sub data_array {
	my $self = shift;
	my $id_kategori = shift;

	my @kategori_id = split /,/, $id_kategori;
	my %search;
	$search{id} = [@kategori_id];
	my $kategori = $self->table('kategori')->search(\%search)->order_by('id');

	return $kategori;
}

1;
