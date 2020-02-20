package dpd;
use strict;
use warnings;
use Mojo::Util qw(sha1_sum dumper);
use Text::CSV;

use db;

sub index {
	my ($c, $log, $db) = @_;

	my $form = $c->form(qw/nama/);

	my $rs = $db->table('dpd');

	my $op = $c->param('op');
	my $id = $c->param('id');
	if($op eq 'tambah'){
		eval{
			$rs ->insert($form);
		};
		if($@){
			$log->info("tambah dpd ".$@);
			$c->redirect_to("/admin/tambah_dpd?info=tambah dpd gagal.&nama=$form->{nama}");
			return;
		}
		$c->redirect_to("/dpd/index?info=tambah dpd berhasil.");
		return;
	}elsif($op eq 'edit'){
		eval{
			$rs ->search({id => $id})->update($form);
		};
		if($@){
			$log->info("edit dpd ".$@);
			$c->redirect_to("/admin/edit_dpd?info=edit dpd gagal.&id=$id");
			return;
		}
		$c->redirect_to("/dpd/index?info=edit dpd berhasil.");
		return;
	}elsif($op eq 'hapus'){
		my @array_id = split/_/, $id;

		$db->dbh->begin_work();
		foreach(@array_id){
			$rs ->search({id => $_})->delete;
		}
		$db->dbh->commit;
		$c->render('data' => 'sukses');
		return;
	}

	$c->redirect_to("/dpd/index");
}

sub kecamatan {
	my ($c, $log, $db) = @_;

	my $form = $c->form(qw/kode nama dpd/);

	my $rs = $db->table('kecamatan');

	my $op = $c->param('op');
	my $id = $c->param('id');
	if($op eq 'tambah'){
		eval{
			$rs ->insert($form);
		};
		if($@){
			$log->info("tambah kecamatan ".$@);
			$c->redirect_to("/dpd/tambah_kecamatan?info=tambah kecamatan gagal.&kode=$form->{kode}&nama=$form->{nama}&dpd=$form->{dpd}");
			return;
		}
		$c->redirect_to("/dpd/kecamatan?info=tambah kecamatan berhasil.");
		return;
	}elsif($op eq 'edit'){
		eval{
			$rs ->search({id => $id})->update($form);
		};
		if($@){
			$log->info("edit kecamatan ".$@);
			$c->redirect_to("/dpd/edit_kecamatan?info=edit kecamatan gagal.&id=$id");
			return;
		}
		$c->redirect_to("/dpd/kecamatan?info=edit kecamatan berhasil.");
		return;
	}elsif($op eq 'hapus'){
		my @array_id = split/_/, $id;

		$db->dbh->begin_work();
		foreach(@array_id){
			$rs ->search({id => $_})->delete;
		}
		$db->dbh->commit;
		$c->render('data' => 'sukses');
		return;
	}

	$c->redirect_to("/dpd/kecamatan");
}

sub upload_kecamatan {
	my ($c, $log, $db) = @_;

	my $op = $c->param('op');
	if($op eq 'download_format'){
		my $data = "kode kecamatan,nama kecamatan,kode kelurahan,nama kelurahan\n";
		$data .= "MT,Matraman\n";
		$data .= ",,PB,Pisangan Baru\n";
		$data .= ",,UK,Utan Kayu Selatan\n";
		$data .= "DS,Duren Sawit\n";
		$data .= ",,PBA,Pondok Bambu\n";
		$data .= ",,DS,Duren Sawit\n";
		$data .= "PG,Pulo Gadung\n";
		$data .= ",,KP,Kayu Putih\n";
		$data .= ",,J,Jati\n";
		$c->render_file('data' => $data, 'file_name' => 'formatKecamatan.csv', 'content_disposition' => 'inline');
		return;
	}elsif($op eq 'upload'){
		my $kecamatan = $db->table('kecamatan');
		my $kelurahan = $db->table('kelurahan');
		my $file = $c->param('csv_file');
		my $dpd = $c->param('dpd');
		my $uid = $c->session->{user}{id};
		my $filename = "download/$uid.csv";
		if ($file and $file->size) {
			$db->dbh->begin_work();

			$file->move_to($filename);
			my $csv = Text::CSV->new({binary => 1});
			open my $fh, "<:encoding(utf8)", $filename or die "$filename: $!";
			my $i = 0;
			my $id_kecamatan = 1;
			while(my $row = $csv->getline($fh)){
				$i++;
				#validasi
				if($i == 1){
					if(lc($row->[0]) ne 'kode kecamatan'){
						$db->dbh->rollback();
						$c->redirect_to("/dpd/upload_kecamatan?info=kode kolom 1 adalah kode kecamatan&dpd=$dpd");
						return;
					}elsif(lc($row->[1]) ne 'nama kecamatan'){
						$db->dbh->rollback();
						$c->redirect_to("/dpd/upload_kecamatan?info=kode kolom 2 adalah nama kecamatan&dpd=$dpd");
						return;
					}elsif(lc($row->[2]) ne 'kode kelurahan'){
						$db->dbh->rollback();
						$c->redirect_to("/dpd/upload_kecamatan?info=kode kolom 3 adalah kode kelurahan&dpd=$dpd");
						return;
					}elsif(lc($row->[3]) ne 'nama kelurahan'){
						$db->dbh->rollback();
						$c->redirect_to("/dpd/upload_kecamatan?info=kode kolom 4 adalah nama kelurahan&dpd=$dpd");
						return;
					}
					next;
				}

				#insert kecamatan
				if($row->[0]){
					my $cek_kecamatan = db::dpd::kecamatan($db,0,0,$row->[0]);
					if($cek_kecamatan){
						$id_kecamatan = $cek_kecamatan->id;
					}else{
						eval{
							my $last_kecamatan = $kecamatan ->insert({dpd => $dpd, kode => $row->[0], nama => $row->[1]});
							$id_kecamatan = $last_kecamatan->id;
						};
						if($@){
							$db->dbh->rollback();
							$log->info("insert kecamatan ".$@);
							$c->redirect_to("/dpd/upload_kecamatan?info=upload kecamatan dan kelurahan gagal.&dpd=$dpd");
							return;
						}
					}
				}
				next unless $row->[2];

				#insert kelurahan
				my $cek_kelurahan = db::dpd::kelurahan($db,0,0,$row->[2]);
				next if $cek_kelurahan;
				eval{
					$kelurahan ->insert({kecamatan => $id_kecamatan, kode => $row->[2], nama => $row->[3]});
				};
				if($@){
					$db->dbh->rollback();
					$log->info("insert kelurahan ".$@);
					$c->redirect_to("/dpd/upload_kecamatan?info=upload kecamatan dan kelurahan gagal.&dpd=$dpd");
					return;
				}
			}

			$db->dbh->commit();
			$c->redirect_to("/dpd/upload_kecamatan?info=upload data telah disimpan.");
			return;
		}
	}

	$c->redirect_to("/dpd/upload_kecamatan");
}

sub kelurahan {
	my ($c, $log, $db) = @_;

	my $form = $c->form(qw/kode nama kecamatan/);

	my $rs = $db->table('kelurahan');

	my $op = $c->param('op');
	my $id = $c->param('id');
	if($op eq 'tambah'){
		eval{
			$rs ->insert($form);
		};
		if($@){
			$log->info("tambah kelurahan ".$@);
			$c->redirect_to("/dpd/tambah_kelurahan?info=tambah kelurahan gagal.&kode=$form->{kode}&nama=$form->{nama}&kecamatan=$form->{kecamatan}");
			return;
		}
		$c->redirect_to("/dpd/kelurahan?info=tambah kelurahan berhasil.");
		return;
	}elsif($op eq 'edit'){
		eval{
			$rs ->search({id => $id})->update($form);
		};
		if($@){
			$log->info("edit kelurahan ".$@);
			$c->redirect_to("/dpd/edit_kelurahan?info=edit kelurahan gagal.&id=$id");
			return;
		}
		$c->redirect_to("/dpd/kelurahan?info=edit kelurahan berhasil.");
		return;
	}elsif($op eq 'hapus'){
		my @array_id = split/_/, $id;

		$db->dbh->begin_work();
		foreach(@array_id){
			$rs ->search({id => $_})->delete;
		}
		$db->dbh->commit;
		$c->render('data' => 'sukses');
		return;
	}

	$c->redirect_to("/dpd/kelurahan");
}

1;
