package db::admin;
use strict;
use warnings;
use parent 'base4db';

sub list {
	my $self = shift;
	my $param = shift;

	my %search;
	$search{nama_lengkap} = {like => $param->('nama_lengkap').'%'} if $param->('nama_lengkap');
	$search{status} = $param->('status') if $param->('status');
	$search{admin_grup} = $param->('admin_grup') if $param->('admin_grup');

	my $page = $param->('_pg') || 1;
	my $per_page = $param->('_per') || 10;
	my $admin = $self->table('admin')->rows_per_page($per_page)->page($page)->search(\%search);
	return $admin;
}

sub data {
	my $self = shift;
	my $id_admin = shift;

	my $data = $self->table('admin')->search({id => $id_admin})->single;

	return $data;
}

sub list_grup {
	my $self = shift;
	my $param = shift;

	my %search;
	$search{nama} = {like => $param->('nama').'%'} if $param->('nama');

	my $page = $param->('_pg') || 1;
	my $per_page = $param->('_per') || 10;
	my $grup = $self->table('admin_grup')->rows_per_page($per_page)->page($page)->search(\%search)->order_by('id');
	return $grup;
}

sub data_grup {
	my $self = shift;
	my $id_grup = shift;

	my $grup;
	if($id_grup){
		$grup = $self->table('admin_grup')->search({id => $id_grup})->single;
	}else{
		$grup = $self->table('admin_grup')->order_by('id');
	}

	return $grup;
}

1;
