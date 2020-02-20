package pengaturan;
use strict;
use warnings;

sub hak_akses {
	my ($c, $log, $db) = @_;

	#field2 isian
	my $form = $c->form(qw/admin_grup halaman/);
	my $halaman = $c->every_param('halaman');

	#table
	my $rs = $db->table('pemetaan'); # table nya

	#detele
	$rs ->search({ admin_grup => $form->{admin_grup}}) ->delete;

	#insert
	my $i = 0;
	foreach(@$halaman){
		$rs ->insert({admin_grup => $form->{admin_grup}, halaman => $halaman->[$i]});
		++$i;
	}

	$c->redirect_to("/pengaturan/hak_akses?admin_grup=$form->{admin_grup}&info=pembaruan hak akses berhasil.");
}

1;
