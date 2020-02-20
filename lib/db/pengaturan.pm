package db::pengaturan;
use strict;
use warnings;
use parent 'base4db';

sub hak_akses {
	my $self = shift;
	my $param = shift;

	my $id_grup = $param->('admin_grup');
	my %page;
	my %left_join;
	$left_join{id} = 'halaman';
	if($id_grup){
		$left_join{'pemetaan.admin_grup'} = {'=', $id_grup};
	}else{
		$left_join{'pemetaan.admin_grup'} = {'=', undef};
	}
	foreach(qw/home admin dpd kategori kegiatan pengaturan bidang/){
		$page{$_} = $self->table('halaman')->search({ 'me.nama' => {'like' => "%/$_/%"} })
		->left_join('pemetaan', \%left_join)
		->select_also('pemetaan.admin_grup');
	}

	return \%page;
}

1;
