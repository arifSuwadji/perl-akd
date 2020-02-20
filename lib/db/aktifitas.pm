package db::aktifitas;
use strict;
use warnings;
use parent 'base4db';

use config;

sub list {
	my $self = shift;
	my $param = shift;

	my %search;
	$search{ts_aktifitas} = [{">", \['STR_TO_DATE(?, "%d-%m-%Y")', $param->('dmy1')],
			"<", \['DATE_ADD(STR_TO_DATE(?, "%d-%m-%Y"), INTERVAL 1 DAY)', $param->('dmy2')]}] if $param->('dmy1') and $param->('dmy2');
	$search{'bidang'} = $param->('bidang') if $param->('bidang');
	$search{'kategori'} = $param->('kategori') if $param->('kategori');
	$search{'kegiatan'} = {like => $param->('kegiatan')."%"} if $param->('kegiatan');
	$search{'kecamatan.dpd'} = $param->('dpd') if $param->('dpd');
	$search{'kelurahan.kecamatan'} = $param->('kecamatan') if $param->('kecamatan');
	$search{'kelurahan'} = $param->('kelurahan') if $param->('kelurahan');
	$search{'rw'} = $param->('rw') if $param->('rw');

	my $page = $param->('_pg') || 1;
	my $per_page = $param->('_per') || 10;
	my $aktifitas = $self->table('aktifitas')
		->inner_join('kategori', {kategori => 'id'})
		->inner_join('kelurahan', {kelurahan => 'id'})
		->inner_join('kecamatan', {'kelurahan.kecamatan' => 'id'})
		->rows_per_page($per_page)->page($page)->search(\%search)->order_by('-ts_aktifitas');
	return $aktifitas;
}

sub list_kelurahan {
	my $self = shift;
	my $param = shift;

	my %search;
	my $month = join '-', reverse split '-', $param->('dmy1');
	$search{ts_aktifitas} = {like => $month."%"} if $param->('dmy1');
	$search{'kelurahan.nama'} = $param->('kelurahan') if $param->('kelurahan');

	my $aktifitas = $self->table('aktifitas')
		->inner_join('kelurahan', {kelurahan => 'id'})
		->search(\%search);
	return $aktifitas;
}

sub data {
	my $self = shift;
	my $id_kegiatan = shift;

	my $data = $self->table('aktifitas')->search({id => $id_kegiatan})->single;
	return $data;
}

sub data_foto {
	my $self = shift;
	my $id_kegiatan = shift;
	my $urut = shift;

	my $data = $self->table('aktifitas_foto')->search({aktifitas => $id_kegiatan, urut => $urut})->single;
	return $data;
}

sub data_skor {
	my $self = shift;
	my $id_aktifitas = shift;

	my $data = $self->table('aktifitas_skor')->search({aktifitas => $id_aktifitas})->single;
	return $data;
}

sub data_grafik {
	my $self = shift;
	my $param = shift;

	my %data;
	my %search;
	my $month = join '-', reverse split '-', $param->('my1');
	$search{ts_aktifitas} = {like => $month."%"} if $param->('my1');

	#kategori & kecamatan
	my $kategori_kecamatan = $self->table('kategori')->search({induk_id => undef});
	while(my $kat = $kategori_kecamatan->next){
		$data{kategori}{$kat->id}{$kat->nama} = 0;
		my $kecamatan = $self->table('kecamatan')->search({dpd => $config::dpd});
		while(my $kec = $kecamatan->next){
			$data{kecamatan}{$kat->id}{$kat->nama}{$kec->kode} = 0;
			my $sub_kategori = $self->table('kategori')->search({induk_id => $kat->id});
			while(my $sub = $sub_kategori->next){
				$search{kategori} = $kat->id;
				my $kelurahan = $self->table('kelurahan')->search({kecamatan => $kec->id});
				while(my $kel = $kelurahan->next){
					$search{kelurahan} = $kel->id;
					my $aktifitas = $self->table('aktifitas')->search(\%search);
					while(my $akt = $aktifitas->next){
						my $skor = $self->table('aktifitas_skor')->search({aktifitas => $akt->id})->single;
						my $nilai = $skor ? $skor->skor : 0;
						$data{kategori}{$kat->id}{$kat->nama} += $nilai;
						$data{kecamatan}{$kat->id}{$kat->nama}{$kec->kode} += $nilai;
					}
				}
			}
		}
	}

	return \%data;
}

sub data_bar_grafik {
	my $self = shift;
	my $param = shift;

	my %data;
	my %search;
	my $month = join '-', reverse split '-', $param->('my1');
	$search{ts_aktifitas} = {like => $month."%"} if $param->('my1');

	my %search_bidang;
	my @id_bidang = split /,/, $param->('bidang');
	$search_bidang{id} = [@id_bidang] if $param->('bidang');

	my %search_kategori;
	$search_kategori{induk_id} = undef;
	my @id_kategori = split /,/, $param->('kategori');
	$search_kategori{id} = {"in", [@id_kategori]} if $param->('kategori');

	my %search_kecamatan;
	$search_kecamatan{dpd} = $config::dpd;
	my @id_kecamatan = split /,/, $param->('dpc');
	$search_kecamatan{id} = {"in", [@id_kecamatan]} if $param->('dpc');

	my %search_kelurahan;
	my @id_kelurahan = split /,/, $param->('dpra');
	$search_kelurahan{id} = {"in", [@id_kelurahan]} if $param->('dpra');

	#kategori & kecamatan
	my $bidang_kecamatan = $self->table('bidang')->search(\%search_bidang)->order_by('id');
	while(my $bid = $bidang_kecamatan->next){
		my $kategori_kecamatan = $self->table('kategori')->search(\%search_kategori);
		while(my $kat = $kategori_kecamatan->next){
			$data{bidang}{$bid->id}{$bid->nama}{$kat->id}{$kat->nama} = 0;
			my $kecamatan = $self->table('kecamatan')->search(\%search_kecamatan);
			while(my $kec = $kecamatan->next){
				$data{kecamatan}{$bid->id}{$bid->nama}{$kat->id}{$kat->nama}{$kec->kode} = 0;
				$search{bidang} = $bid->id;
				$search{kategori} = $kat->id;
				$search_kelurahan{kecamatan} = $kec->id;
				my $kelurahan = $self->table('kelurahan')->search(\%search_kelurahan);
				while(my $kel = $kelurahan->next){
					$search{kelurahan} = $kel->id;
					my $aktifitas = $self->table('aktifitas')->search(\%search);
					while(my $akt = $aktifitas->next){
						my $skor = $self->table('aktifitas_skor')->search({aktifitas => $akt->id})->single;
						my $nilai = $skor ? $skor->skor : 0;
						$data{bidang}{$bid->id}{$bid->nama}{$kat->id}{$kat->nama} += $nilai;
						$data{kecamatan}{$bid->id}{$bid->nama}{$kat->id}{$kat->nama}{$kec->kode} += $nilai;
					}
				}
			}
		}
	}

	return \%data;
}

sub data_bar_grafik_dpc {
	my $self = shift;
	my $param = shift;

	my %data;
	my %search;
	my $month = join '-', reverse split '-', $param->('my1');
	$search{ts_aktifitas} = {like => $month."%"} if $param->('my1');

	my %search_bidang;
	my @id_bidang = split /,/, $param->('bidang');
	$search_bidang{id} = [@id_bidang] if $param->('bidang');

	my %search_kategori;
	$search_kategori{induk_id} = undef;
	my @id_kategori = split /,/, $param->('kategori');
	$search_kategori{id} = {"in", [@id_kategori]} if $param->('kategori');

	my %search_kecamatan;
	$search_kecamatan{dpd} = $config::dpd;
	my @id_kecamatan = split /,/, $param->('dpc');
	$search_kecamatan{id} = {"in", [@id_kecamatan]} if $param->('dpc');

	my %search_kelurahan;
	my @id_kelurahan = split /,/, $param->('dpra');
	$search_kelurahan{id} = {"in", [@id_kelurahan]} if $param->('dpra');

	#kategori & kecamatan
	my $bidang_kecamatan = $self->table('bidang')->search(\%search_bidang)->order_by('id');
	while(my $bid = $bidang_kecamatan->next){
		my $kategori_kecamatan = $self->table('kategori')->search(\%search_kategori);
		while(my $kat = $kategori_kecamatan->next){
			$data{bidang}{$bid->id}{$bid->nama}{$kat->id}{$kat->nama} = 0;
			my $kecamatan = $self->table('kecamatan')->search(\%search_kecamatan);
			while(my $kec = $kecamatan->next){
				$search{bidang} = $bid->id;
				$search{kategori} = $kat->id;
				$search_kelurahan{kecamatan} = $kec->id;
				my $kelurahan = $self->table('kelurahan')->search(\%search_kelurahan);
				while(my $kel = $kelurahan->next){
					$data{kelurahan}{$bid->id}{$bid->nama}{$kat->id}{$kat->nama}{$kel->kode} = 0;
					$search{kelurahan} = $kel->id;
					my $aktifitas = $self->table('aktifitas')->search(\%search);
					while(my $akt = $aktifitas->next){
						my $skor = $self->table('aktifitas_skor')->search({aktifitas => $akt->id})->single;
						my $nilai = $skor ? $skor->skor : 0;
						$data{bidang}{$bid->id}{$bid->nama}{$kat->id}{$kat->nama} += $nilai;
						$data{kelurahan}{$bid->id}{$bid->nama}{$kat->id}{$kat->nama}{$kel->kode} += $nilai;
					}
				}
			}
		}
	}

	return \%data;
}

sub data_grafik_kategori_dpc {
	my $self = shift;
	my $param = shift;

	my %data;
	my %search;
	my $month = join '-', reverse split '-', $param->('my1');
	$search{ts_aktifitas} = {like => $month."%"} if $param->('my1');

	#kategori & kecamatan
	my $kategori_kecamatan = $self->table('kategori')->search({induk_id => undef});
	while(my $kat = $kategori_kecamatan->next){
		$data{kategori}{$kat->id}{$kat->nama} = 0;
		my $kecamatan = $self->table('kecamatan')->search({id => $param->('dpc')});
		while(my $kec = $kecamatan->next){
			#default kelurahan
			my $kel_default = $self->table('kelurahan')->search({kecamatan => $kec->id});
			while(my $kdef = $kel_default->next){
				$data{kelurahan}{$kat->id}{$kat->nama}{$kdef->kode} = 0;
			}
			my $sub_kategori = $self->table('kategori')->search({induk_id => $kat->id});
			while(my $sub = $sub_kategori->next){
				$search{kategori} = $sub->id;
				my $kelurahan = $self->table('kelurahan')->search({kecamatan => $kec->id});
				while(my $kel = $kelurahan->next){
					$search{kelurahan} = $kel->id;
					my $aktifitas = $self->table('aktifitas')->search(\%search);
					while(my $akt = $aktifitas->next){
						my $skor = $self->table('aktifitas_skor')->search({aktifitas => $akt->id})->single;
						my $nilai = $skor ? $skor->skor : 0;
						$data{kategori}{$kat->id}{$kat->nama} += $nilai;
						$data{kelurahan}{$kat->id}{$kat->nama}{$kel->kode} += $nilai;
					}
				}
			}
		}
	}

	return \%data;
}

sub data_grafik_kategori_dpra {
	my $self = shift;
	my $param = shift;

	my %data;
	my %search;
	my $month = join '-', reverse split '-', $param->('my1');
	$search{ts_aktifitas} = {like => $month."%"} if $param->('my1');

	#kategori & kecamatan
	my $kategori_kecamatan = $self->table('kategori')->search({induk_id => undef});
	while(my $kat = $kategori_kecamatan->next){
		$data{kategori}{$kat->id}{$kat->nama} = 0;
		my $sub_kategori = $self->table('kategori')->search({induk_id => $kat->id});
		while(my $sub = $sub_kategori->next){
			$search{kategori} = $sub->id;
			my $kelurahan = $self->table('kelurahan')->search({kecamatan => $param->('dpc'), id => $param->('dpra')});
			while(my $kel = $kelurahan->next){
				$search{kelurahan} = $kel->id;
				my $aktifitas = $self->table('aktifitas')->search(\%search);
				while(my $akt = $aktifitas->next){
					my $skor = $self->table('aktifitas_skor')->search({aktifitas => $akt->id})->single;
					my $nilai = $skor ? $skor->skor : 0;
					$data{kategori}{$kat->id}{$kat->nama} += $nilai;
				}
			}
		}
	}

	return \%data;
}


sub data_grafik_kegiatan {
	my $self = shift;
	my $param = shift;

	my %data;
	my %search;
	my $month = join '-', reverse split '-', $param->('my1');
	$search{ts_aktifitas} = {like => $month."%"} if $param->('my1');

	#kegiatan & kecamatan
	my $kategori_kecamatan = $self->table('kategori')->search({induk_id => {'>', 0}});
	while(my $kat = $kategori_kecamatan->next){
		$data{kategori}{$kat->id}{$kat->nama} = 0;
		$search{kategori} = $kat->id;
		my $kecamatan = $self->table('kecamatan')->search({dpd => $config::dpd});
		while(my $kec = $kecamatan->next){
			$data{kecamatan}{$kat->id}{$kat->nama}{$kec->kode} = 0;
			my $kelurahan = $self->table('kelurahan')->search({kecamatan => $kec->id});
			while(my $kel = $kelurahan->next){
				$search{kelurahan} = $kel->id;
				my $aktifitas = $self->table('aktifitas')->search(\%search);
				while(my $akt = $aktifitas->next){
					my $skor = $self->table('aktifitas_skor')->search({aktifitas => $akt->id})->single;
					my $nilai = $skor ? $skor->skor : 0;
					$data{kategori}{$kat->id}{$kat->nama} += $nilai;
					$data{kecamatan}{$kat->id}{$kat->nama}{$kec->kode} += $nilai;
				}
			}
		}
	}

	return \%data;
}

sub data_grafik_kegiatan_dpc {
	my $self = shift;
	my $param = shift;

	my %data;
	my %search;
	my $month = join '-', reverse split '-', $param->('my1');
	$search{ts_aktifitas} = {like => $month."%"} if $param->('my1');

	#kegiatan & kecamatan
	my $kategori_kecamatan = $self->table('kategori')->search({induk_id => {'>', 0}});
	while(my $kat = $kategori_kecamatan->next){
		$data{kategori}{$kat->id}{$kat->nama} = 0;
		$search{kategori} = $kat->id;
		my $kecamatan = $self->table('kecamatan')->search({id => $param->('dpc')});
		while(my $kec = $kecamatan->next){
			#default kelurahan
			my $kel_default = $self->table('kelurahan')->search({kecamatan => $kec->id});
			while(my $kdef = $kel_default->next){
				$data{kelurahan}{$kat->id}{$kat->nama}{$kdef->kode} = 0;
			}
			my $kelurahan = $self->table('kelurahan')->search({kecamatan => $kec->id});
			while(my $kel = $kelurahan->next){
				$search{kelurahan} = $kel->id;
				my $aktifitas = $self->table('aktifitas')->search(\%search);
				while(my $akt = $aktifitas->next){
					my $skor = $self->table('aktifitas_skor')->search({aktifitas => $akt->id})->single;
					my $nilai = $skor ? $skor->skor : 0;
					$data{kategori}{$kat->id}{$kat->nama} += $nilai;
					$data{kelurahan}{$kat->id}{$kat->nama}{$kel->kode} += $nilai;
				}
			}
		}
	}

	return \%data;
}

sub data_grafik_kegiatan_dpra {
	my $self = shift;
	my $param = shift;

	my %data;
	my %search;
	my $month = join '-', reverse split '-', $param->('my1');
	$search{ts_aktifitas} = {like => $month."%"} if $param->('my1');

	#kegiatan & kecamatan
	my $kategori_kecamatan = $self->table('kategori')->search({induk_id => {'>', 0}});
	while(my $kat = $kategori_kecamatan->next){
		$data{kategori}{$kat->id}{$kat->nama} = 0;
		$search{kategori} = $kat->id;
		my $kelurahan = $self->table('kelurahan')->search({kecamatan => $param->('dpc'), id => $param->('dpra')});
		while(my $kel = $kelurahan->next){
			$search{kelurahan} = $kel->id;
			my $aktifitas = $self->table('aktifitas')->search(\%search);
			while(my $akt = $aktifitas->next){
				my $skor = $self->table('aktifitas_skor')->search({aktifitas => $akt->id})->single;
				my $nilai = $skor ? $skor->skor : 0;
				$data{kategori}{$kat->id}{$kat->nama} += $nilai;
			}
		}
	}

	return \%data;
}

sub data_kalender {
	my $self = shift;
	my $tahun = shift;

	my $data = $self->table('aktifitas')->search({ts_aktifitas => {'like', $tahun."%"}});
	return $data;
}

1;
