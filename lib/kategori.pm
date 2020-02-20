package kategori;
use strict;
use warnings;
use Mojo::Util qw(sha1_sum dumper);

use db;

sub index {
	my ($c, $log, $db) = @_;

	my $form = $c->form(qw/nama induk_id/);
	$form->{induk_id} = undef unless $form->{induk_id};

	my $rs = $db->table('kategori');

	my $op = $c->param('op');
	my $id = $c->param('id');
	my $id_sub = $c->param('id_sub');
	if($op eq 'tambah'){
		$db->dbh->begin_work();
		eval{
			$rs ->insert($form);
		};
		if($@){
			$log->info("tambah kategori ".$@);
			$db->dbh->rollback();
			$c->redirect_to("/kategori/tambah_kategori?info=tambah kategori gagal.&nama=$form->{nama}&induk=$form->{induk}");
			return;
		}
		$db->dbh->commit;
		$c->redirect_to("/kategori/index?info=tambah kategori berhasil.");
		return;
	}elsif($op eq 'edit'){
		$db->dbh->begin_work();
		eval{
			if($form->{induk_id}){
				$rs ->search({id => $id_sub})->update($form);
			}else{
				$rs ->search({id => $id})->update($form);
			}
		};
		if($@){
			$log->info("edit kategori ".$@);
			$db->dbh->rollback();
			$c->redirect_to("/kategori/edit_kategori?info=edit kategori gagal.&id=$id&id_sub=$id_sub");
			return;
		}
		$db->dbh->commit;
		$c->redirect_to("/kategori/index?info=edit kategori berhasil.");
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
	$c->redirect_to("/kategori/index");
}

1;
