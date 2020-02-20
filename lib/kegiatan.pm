package kegiatan;
use strict;
use warnings;
use Mojo::Util qw(sha1_sum dumper);

use Excel::Writer::XLSX;

use db;

sub index {
	my ($c, $log, $db) = @_;

	my $form_dukung = $c->form(qw/induk_kategori dpd kecamatan/);
	my $form = $c->form(qw/bidang kategori kegiatan level kelurahan rw alamat koordinat keterangan target realisasi/);
	$form->{alamat} = undef unless $form->{alamat};
	$form->{koordinat} = undef unless $form->{koordinat};
	$form->{target} =~ s/\,//g;
	$form->{realisasi} =~ s/\,//g;
	$form->{ts_aktifitas} = \"NOW()";
	my $form_nilai = $c->form(qw/tipe skor/);
	my $dmy1 = db->now->dmy;

	my $rs = $db->table('aktifitas');
	my $rs_foto = $db->table('aktifitas_foto');
	my $rs_nilai = $db->table('aktifitas_skor');

	my $op = $c->param('op');
	my $id = $c->param('id');
	my $foto = $c->every_param('foto');
	if($op eq 'tambah'){
		my $last_aktifitas;
		$db->dbh->begin_work();
		eval{
			$last_aktifitas = $rs ->insert($form);
		};
		if($@){
			$log->info("insert aktifitas ".$@);
			$db->dbh->rollback();
			$c->redirect_to("/kegiatan/entri_kegiatan?info=entri kegiatan gagal.&bidang=$form->{bidang}&kategori=$form->{kategori}&kegiatan=$form->{kegiatan}&level=$form->{level}&deskripsi=$form->{keterangan}&dpd=$form_dukung->{dpd}&kecamatan=$form_dukung->{kecamatan}&kelurahan=$form->{kelurahan}&rw=$form->{rw}&alamat=$form->{alamat}&koordinat=$form->{koordinat}&target=$form->{target}&realisasi=$form->{realisasi}");
			return;
		}
		eval{
			my $i = 0;
			foreach(@$foto){
				if($_ and $_->slurp){
					$i++;
					my $filename = "foto/".$last_aktifitas->id."_".$i.".jpg";
					$_->move_to($filename);
					#$rs_foto ->insert({aktifitas => $last_aktifitas->id, foto => $_->slurp, urut => $i});
				}
			}
		};
		if($@){
			$log->info("insert aktifitas foto ".$@);
			$db->dbh->rollback();
			$c->redirect_to("/kegiatan/entri_kegiatan?info=entri kegiatan gagal.&bidang=$form->{bidang}&kategori=$form->{kategori}&kegiatan=$form->{kegiatan}&level=$form->{level}&deskripsi=$form->{keterangan}&dpd=$form_dukung->{dpd}&kecamatan=$form_dukung->{kecamatan}&kelurahan=$form->{kelurahan}&rw=$form->{rw}&alamat=$form->{alamat}&koordinat=$form->{koordinat}&target=$form->{target}&realisasi=$form->{realisasi}");
			return;
		}
		$db->dbh->commit;
		$c->redirect_to("/kegiatan/index?info=entri kegiatan berhasil.&dmy1=$dmy1&dmy2=$dmy1");
		return;
	}elsif($op eq 'edit'){
		delete $form->{ts_aktifitas};
		$db->dbh->begin_work();
		eval{
			$rs ->search({id => $id})->update($form);
		};
		if($@){
			$log->info("edit aktifitas ".$@);
			$db->dbh->rollback();
			$c->redirect_to("/kegiatan/edit_kegiatan?info=simpan detail kegiatan gagal.&id=$id");
			return;
		}
		my $foto1 = $c->param('foto_1');
		my $foto2 = $c->param('foto_2');
		my $foto3 = $c->param('foto_3');
		my $foto4 = $c->param('foto_4');
		eval{
			if($foto1 and $foto1->slurp){
				my $filename = "foto/".$id."_1.jpg";
				$foto1->move_to($filename);
=head
				my $cek_foto = db::aktifitas::data_foto($db, $id, 1);
				if($cek_foto){
					$rs_foto ->search({aktifitas => $id, urut => 1})->update({foto => $foto1->slurp});
				}else{
					$rs_foto ->insert({aktifitas => $id, foto => $foto1->slurp, urut => 1});
				}
=cut
			}
			if($foto2 and $foto2->slurp){
				my $filename = "foto/".$id."_2.jpg";
				$foto1->move_to($filename);
=head
				my $cek_foto = db::aktifitas::data_foto($db, $id, 2);
				if($cek_foto){
					$rs_foto ->search({aktifitas => $id, urut => 2})->update({foto => $foto2->slurp});
				}else{
					$rs_foto ->insert({aktifitas => $id, foto => $foto2->slurp, urut => 2});
				}
=cut
			}
			if($foto3 and $foto3->slurp){
				my $filename = "foto/".$id."_3.jpg";
				$foto1->move_to($filename);
=head
				my $cek_foto = db::aktifitas::data_foto($db, $id, 3);
				if($cek_foto){
					$rs_foto ->search({aktifitas => $id, urut => 3})->update({foto => $foto3->slurp});
				}else{
					$rs_foto ->insert({aktifitas => $id, foto => $foto3->slurp, urut => 3});
				}
=cut
			}
			if($foto4 and $foto4->slurp){
				my $filename = "foto/".$id."_4.jpg";
				$foto1->move_to($filename);
=head
				my $cek_foto = db::aktifitas::data_foto($db, $id, 4);
				if($cek_foto){
					$rs_foto ->search({aktifitas => $id, urut => 4})->update({foto => $foto4->slurp});
				}else{
					$rs_foto ->insert({aktifitas => $id, foto => $foto3->slurp, urut => 4});
				}
=cut
			}
		};
		if($@){
			$log->info("edit aktifitas ".$@);
			$db->dbh->rollback();
			$c->redirect_to("/kegiatan/edit_kegiatan?info=simpan detail kegiatan gagal.&id=$id");
			return;
		}
		$db->dbh->commit;
		$c->redirect_to("/kegiatan/index?info=simpan detail kegiatan berhasil.&dmy1=$dmy1&dmy2=$dmy1");
		return;
	}elsif($op eq 'nilai'){
		$form_nilai->{aktifitas} = $id;
		eval{
			my $cek_nilai = db::aktifitas::data_skor($db, $id);
			if($cek_nilai){
				delete $form_nilai->{aktifitas};
				$rs_nilai ->search({aktifitas => $id})->update($form_nilai);
			}else{
				$rs_nilai ->insert($form_nilai);
			}
		};
		if($@){
			$log->info("skor kegiatan ".$@);
			$c->redirect_to("/kegiatan/nilai_kegiatan?info=nilai kegiatan gagal disimpan.&id=$id&tipe=$form_nilai->{tipe}&skor=$form_nilai->{skor}");
			return;
		}
		$c->redirect_to("/kegiatan/index?info=nilai kegiatan berhasil disimpan.&dmy1=$dmy1&dmy2=$dmy1");
		return;
	}

	$c->redirect_to("/kegiatan/index");
}

sub sub_kategori {
	my ($c, $log, $db) = @_;

	my $form = $c->form(qw/id/);

	my $sub;
	if($form->{id}){
		$sub = db::kategori::induk($db,$form->{id});
	}else{
		$sub = db::kategori::sub_induk($db);
	}

	my $data = "";
	while(my $row = $sub->next){
		$data .= $row->id."_".$row->nama."|";
	}

	$c->render('data' => $data);
	return;
}

sub kecamatan {
	my ($c, $log, $db) = @_;

	my $form = $c->form(qw/dpd kecamatan/);

	my $kec;
	if($form->{kecamatan}){
		$kec = db::dpd::kecamatan($db,$form->{kecamatan});
	}elsif($form->{dpd}){
		$kec = db::dpd::kecamatan($db,0,$form->{dpd});
	}else{
		$kec = db::dpd::kecamatan($db);
	}

	my $data = "";
	if($form->{kecamatan}){
		$data = $kec->nama;
	}else{
		while(my $row = $kec->next){
			$data .= $row->id."_".$row->nama."|";
		}
	}

	$c->render('data' => $data);
	return;
}

sub kelurahan {
	my ($c, $log, $db) = @_;

	my $form = $c->form(qw/kecamatan kelurahan/);

	my $kel;
	if($form->{kelurahan}){
		$kel = db::dpd::kelurahan($db, $form->{kelurahan});
	}elsif($form->{kecamatan}){
		$kel= db::dpd::kelurahan($db,0,$form->{kecamatan});
	}

	my $data = "";
	if($form->{kelurahan}){
		$data = $kel->nama;
	}elsif($form->{kecamatan}){
		while(my $row = $kel->next){
			$data .= $row->id."_".$row->nama."|";
		}
	}

	$c->render('data' => $data);
	return;
}

sub data_kegiatan {
	my ($c, $log, $db) = @_;

	# Create a new Excel workbook
	my $workbook = Excel::Writer::XLSX->new('download/dataKegiatan.xlsx' );

	# Add a worksheet
	my $worksheet = $workbook->add_worksheet();

	# Add and define a format
	my $format_header = $workbook->add_format();
	$format_header->set_bold();

	my $form = $c->form(qw/dmy1 dmy2 bidang kategori kegiatan dpd kecamatan kelurahan rw/);

	my $data_dpd = db::dpd::data($db, $form->{dpd});
	my $nama_dpd = $form->{dpd} ? $data_dpd->nama : "" ;
	my $judul = 'Data Kegiatan DPD PKS '. $nama_dpd;
	$worksheet->write( 'A1', $judul, $format_header);

	my $tanggal = 'Tanggal '.$form->{dmy1}.' s/d '.$form->{dmy2};
	$worksheet->write( 'A2', $tanggal, $format_header);

	my $format_judul = $workbook->add_format();
	$format_judul->set_bold();
	$format_judul->set_align( 'center' );

	$worksheet->write( 'A4', 'No', $format_judul);
	$worksheet->write( 'B4', 'Data Kegiatan', $format_judul);
	$worksheet->write( 'G4', 'Lokasi Kegiatan', $format_judul);
	$worksheet->write( 'K4', 'Jumlah Peserta', $format_judul);
	$worksheet->write( 'N4', 'Penilaian', $format_judul);

	$worksheet->write( 'B5', 'Tanggal', $format_judul);
	$worksheet->write( 'C5', 'Bidang', $format_judul);
	$worksheet->write( 'D5', 'Kategori', $format_judul);
	$worksheet->write( 'E5', 'Kegiatan', $format_judul);
	$worksheet->write( 'F5', 'Deskripsi', $format_judul);
	$worksheet->write( 'G5', 'DPD', $format_judul);
	$worksheet->write( 'H5', 'Kecamatan', $format_judul);
	$worksheet->write( 'I5', 'Kelurahan', $format_judul);
	$worksheet->write( 'J5', 'RW', $format_judul);
	$worksheet->write( 'K5', 'Target', $format_judul);
	$worksheet->write( 'L5', 'Realisasi', $format_judul);
	$worksheet->write( 'M5', 'Persen (%)', $format_judul);
	$worksheet->write( 'N5', 'Tipe', $format_judul);
	$worksheet->write( 'O5', 'Skor', $format_judul);

	my %search;
	$search{ts_aktifitas} = [{">", \['STR_TO_DATE(?, "%d-%m-%Y")', $form->{dmy1}],
			"<", \['DATE_ADD(STR_TO_DATE(?, "%d-%m-%Y"), INTERVAL 1 DAY)', $form->{dmy2}]}] if $form->{dmy1} and $form->{dmy2};

	$search{'bidang'} = $form->{bidang} if $form->{bidang};
	$search{'kategori'} = $form->{kategori} if $form->{kategori};
	$search{'kegiatan'} = {like => $form->{kegiatan}."%"} if $form->{kegiatan};
	$search{'kecamatan.dpd'} = $form->{dpd} if $form->{dpd};
	$search{'kelurahan.kecamatan'} = $form->{kecamatan} if $form->{kecamatan};
	$search{'kelurahan'} = $form->{kelurahan} if $form->{kelurahan};
	$search{'rw'} = $form->{rw} if $form->{rw};

	my $aktifitas = $db->table('aktifitas')
		->inner_join('kategori', {kategori => 'id'})
		->inner_join('kelurahan', {kelurahan => 'id'})
		->inner_join('kecamatan', {'kelurahan.kecamatan' => 'id'})
		->search(\%search);
	my $i = 0;
	my $line = 5;
	my $format_kanan = $workbook->add_format();
	$format_kanan->set_align( 'right' );
	while(my $row = $aktifitas->next){
		++$line;
		my $bidang = db::bidang::data($db, $row->bidang);
		my $kategori = db::kategori::data($db, $row->kategori);
		my $kelurahan = db::dpd::kelurahan($db, $row->kelurahan);
		my $kecamatan = db::dpd::kecamatan($db, $kelurahan->kecamatan);
		my $dpd = db::dpd::data($db, $kecamatan->dpd);
		my $nilai = db::aktifitas::data_skor($db, $row->id);
		my $tipe = $nilai ? $nilai->tipe eq 'frekuensi' ? 'Frekuensi' : 'Jumlah Peserta' : '';
		my $skor = $nilai ? $nilai->skor : '';
		my $persen = sprintf('%.2f',$row->realisasi / $row->target * 100);

		$worksheet->write( 'A'.$line, ++$i,$format_kanan);
		$worksheet->write( 'B'.$line, db->format_ts($row->ts_aktifitas));
		$worksheet->write( 'C'.$line, $bidang->nama);
		$worksheet->write( 'D'.$line, $kategori->nama);
		$worksheet->write( 'E'.$line, $row->kegiatan);
		$worksheet->write( 'F'.$line, $row->keterangan);
		$worksheet->write( 'G'.$line, $dpd->nama);
		$worksheet->write( 'H'.$line, $kecamatan->nama);
		$worksheet->write( 'I'.$line, $kelurahan->nama);
		$worksheet->write( 'J'.$line, $row->rw);
		$worksheet->write( 'K'.$line, $row->target);
		$worksheet->write( 'L'.$line, $row->realisasi);
		#$worksheet->write( 'M'.$line, "=(L$line/K$line)*100");
		$worksheet->write( 'M'.$line, $persen);
		$worksheet->write( 'N'.$line, $tipe);
		$worksheet->write( 'O'.$line, $skor);
	}

	$c->render_file(
		'filepath' => 'download/dataKegiatan.xlsx',
		'format'   => 'application/x-download',
		'content_disposition' => 'inline',
		'cleanup'  => 1,
	);
	return;
}

1;
