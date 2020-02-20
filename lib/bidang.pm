package bidang;
use strict;
use warnings;
use Mojo::Util qw(sha1_sum dumper);

use db;

sub index {
	my ($c, $log, $db) = @_;

	my $form = $c->form(qw/nama/);

	my $rs = $db->table('bidang');

	my $op = $c->param('op');
	my $id = $c->param('id');
	my $id_sub = $c->param('id_sub');
	if($op eq 'tambah'){
		$db->dbh->begin_work();
		eval{
			$rs ->insert($form);
		};
		if($@){
			$log->info("tambah bidang ".$@);
			$db->dbh->rollback();
			$c->redirect_to("/bidang/tambah_bidang?info=tambah bidang gagal.&nama=$form->{nama}");
			return;
		}
		$db->dbh->commit;
		$c->redirect_to("/bidang/index?info=tambah bidang berhasil.");
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
			$log->info("edit bidang ".$@);
			$db->dbh->rollback();
			$c->redirect_to("/bidang/edit_bidang?info=edit bidang gagal.&id=$id&id_sub=$id_sub");
			return;
		}
		$db->dbh->commit;
		$c->redirect_to("/bidang/index?info=edit bidang berhasil.");
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
	$c->redirect_to("/bidang/index");
}

1;
