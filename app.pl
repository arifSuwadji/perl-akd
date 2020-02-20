#!/usr/bin/perl
use Mojolicious::Lite;
use Session::Token;
use Mojo::Util qw(sha1_sum dumper url_escape url_unescape);

use lib 'lib';
use db;
use config;

plugin 'Number::Commify';
plugin 'RenderFile';

helper form => sub {
	my ($c, @param) = @_;
	my %form; $form{$_} = $c->param($_) foreach @param;
	return \%form;
};

helper db => sub {
	my ($c) = @_;
	my $db = $c->stash('_db');
	return $db if $db;

	my $dbix = DBIx::Lite->new(schema => $db::schema) ->connect(@config::db_conn);
	$db = db->new($dbix, app->log);
	$c->stash(_db => $db);
	return $db;
};

post '/login' => sub {
	my $c = shift;
	my $form = $c->form(qw/username password/);
	$form->{password} = sha1_sum( $form->{password} );

	my $row = $c->db->table('admin') ->find($form);
	if($row){
		# gagal login jika status admin tidak aktif
		if($row->status eq 'tidak'){
			$c->redirect_to("/logout?info=user anda dinonaktifkan...");
			return;
		}

		# assign session_id yg unique
		my $token = Session::Token->new(length => 10)->get;
		$c->db->table('admin')->search({ id => $row->id})->update({ session_id => $token, akses_terakhir => \"NOW()" });
		$c->session->{user} = { %{$row->hashref}, session_id => $token };
=head
		# auto login
		if($c->session->{user}{login_lite} eq 'ya'){
			$c->session(expiration => 0);
		}
=cut
		# pemetaan halaman
		my $pemetaan = $c->db->table('pemetaan')->search({admin_grup => $c->session->{user}{admin_grup}});
		my %data_pemetaan;
		while(my $row = $pemetaan->next){
			$data_pemetaan{$row->halaman} = $row->admin_grup;
		}
		$c->session->{pemetaan}= \%data_pemetaan;
		$c->redirect_to('/home/index?year='.db->now->year);
	}else{
		$c->redirect_to("/logout?info=password yang anda masukkan salah...");
	}
};

any '/logout' => sub {
	my $c = shift;
	$c->session->{user} = undef;
	$c->render(template => 'login')
};

get '/picture/:person_table' => sub {
	my $c = shift;
	my $id = $c->param('id');
	my $urut = $c->param('urut');
	my $row = $c->db ->table($c->stash('person_table'))
		->search({aktifitas => $id, urut => $urut})->single;

	my $foto = $row ? $row->foto : '';

	$c->render(data => $foto);
};

get '/picture_folder/:folder' => sub {
	my $c = shift;
	my $id = $c->param('id');
	my $urut = $c->param('urut');

	my $foto = "foto/$id"."_"."$urut.jpg";
	$c->render_file('filepath' => $foto);
};

get '/misc/:package/:sub' => sub {
	my $c = shift;
	return $c->render(template => 'redirect')
		unless $c->session->{user};

	my ($package, $sub) = ($c->stash('package'), $c->stash('sub'));
	app->log->debug("require $package");
	eval "require $package";
	my $sub_ref = eval '\&'.$package."::$sub";
	return $sub_ref->($c, app->log, $c->db);
};

get '/search/:dir/:page' => sub{
	my $c = shift;
	my ($dir, $page) = ($c->stash('dir'), $c->stash('page'));
	$c->render(template => $dir. '/'.$page);
};

any '/:dir/:page' => sub {
	my $c = shift;
	return $c->render(template => 'redirect')
		unless $c->session->{user};

	my ($dir, $page) = ($c->stash('dir'), $c->stash('page'));
	my $halaman = $c->db ->table('halaman')->search({nama => "/$dir/$page"})->single;
	return $c->render('template' => 'data_halaman') unless $halaman;

	my $pemetaan = $c->db ->table('pemetaan') ->search({admin_grup => $c->session->{user}{admin_grup}, halaman => $halaman->id})->single;
	return $c->render(template => 'akses_dilarang')
		unless $pemetaan;

	if ($c->req->method eq 'POST') {
		app->log->debug("require $dir");
		eval "require $dir";
		my $sub_ref = eval '\&'.$dir."::$page";
		return $sub_ref->($c, app->log, $c->db);
	}

	#check user login and kick user
	my $user = $c->db->table('admin') ->find({id => $c->session->{user}{id}});
	if($user){
		return $c->render(template => 'redirect') unless ($user->session_id eq $c->session->{user}{session_id});
	}

	$c->db->table('admin')->search({id => $c->session->{user}{id}})->update({akses_terakhir => \"NOW()"});

	$c->render(template => $dir. '/'. $page);
};

app->log->level('debug');
app->log->path('/log/akd/app.log');
app->config(hypnotoad => {listen => ["http://*:$config::port_app"], clients => 50, workers => 5, pid_file => '/log/akd/app.pid'});
app->secrets(['Nqrz<.FJ%^&*VN__Qj"fss/?@:;@(),`~!|\!--']);
app->start;

