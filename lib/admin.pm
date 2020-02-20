package admin;
use strict;
use warnings;
use Mojo::Util qw(sha1_sum dumper);

use db;

sub index {
	my ($c, $log, $db) = @_;

	my $form = $c->form(qw/username password nama_lengkap admin_grup status/);
	$form->{password} = sha1_sum($form->{password});

	my $rs = $db->table('admin');
	my $op = $c->param('op');
	my $id = $c->param('id');
	if($op eq 'tambah'){
		delete $form->{status} unless $form->{status};
		eval{
			$rs ->insert($form);
		};
		if($@){
			$log->info("tambah admin ".$@);
			delete $form->{password};
			$c->redirect_to("/admin/tambah_admin?info=tambah admin gagal.&admin=$form->{username}&password=$form->{password}&nama_lengkap=$form->{nama_lengkap}&admin_grup=$form->{admin_grup}");
			return;
		}
		$c->redirect_to("/admin/index?info=tambah admin berhasil.&status=aktif");
		return;
	}elsif($op eq 'edit'){
		delete $form->{password} unless $form->{password};
		eval{
			$rs ->search({id => $id})->update($form);
		};
		if($@){
			$log->info("edit admin ".$@);
			$c->redirect_to("/admin/edit_admin?info=edit admin gagal.&id=$id");
			return;
		}
		$c->redirect_to("/admin/index?info=edit admin berhasil.&status=aktif");
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
	$c->redirect_to("/admin/index?status=aktif");
}

sub admin_grup {
	my ($c, $log, $db) = @_;

	my $form = $c->form(qw/nama/);

	my $rs = $db->table('admin_grup');

	my $op = $c->param('op');
	my $id = $c->param('id');
	if($op eq 'tambah'){
		eval{
			$rs ->insert($form);
		};
		if($@){
			$log->info("tambah admin grup ".$@);
			$c->redirect_to("/admin/tambah_admin_grup?info=tambah admin grup gagal.&nama=$form->{nama}");
			return;
		}
		$c->redirect_to("/admin/admin_grup?info=tambah admin grup berhasil.");
		return;
	}elsif($op eq 'edit'){
		eval{
			$rs ->search({id => $id})->update($form);
		};
		if($@){
			$log->info("edit admin grup ".$@);
			$c->redirect_to("/admin/edit_admin_grup?info=edit admin grup gagal.&id=$id");
			return;
		}
		$c->redirect_to("/admin/admin_grup?info=edit admin grup berhasil.");
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

	$c->redirect_to("/admin/admin_grup");
}

1;
