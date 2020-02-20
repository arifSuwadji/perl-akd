package db;
use strict;
use warnings;
use parent 'base4db';

use Time::Piece;
use DBIx::Lite;

our $schema = DBIx::Lite::Schema->new;
$schema->table('admin')->autopk('id');
$schema->table('admin_grup')->autopk('id');
$schema->table('dpd')->autopk('id');
$schema->table('kecamatan')->autopk('id');
$schema->table('kelurahan')->autopk('id');
$schema->table('halaman')->autopk('id');
$schema->table('kategori')->autopk('id');
$schema->table('bidang')->autopk('id');
$schema->table('aktifitas')->autopk('id');

use db::admin;
sub admin { db::admin->new( @{$_[0]}{qw/dbix log/} ) }

use db::dpd;
sub dpd { db::dpd->new( @{$_[0]}{qw/dbix log/} ) }

use db::kategori;
sub kategori { db::kategori->new( @{$_[0]}{qw/dbix log/} ) }

use db::bidang;
sub bidang{ db::bidang->new( @{$_[0]}{qw/dbix log/} ) }

use db::aktifitas;
sub aktifitas { db::aktifitas->new( @{$_[0]}{qw/dbix log/}) }

use db::pengaturan;
sub pengaturan { db::pengaturan->new (@{$_[0]}{qw/dbix log/} ) }


# ## ###  Biz app methods  ######## ##### ### ## # #  #   #

sub now {localtime()}
sub format_ts {
	my ($db, $mysql_ts_string, $with_time) = @_;

	my $fmt_in = "%Y-%m-%d"; $fmt_in .= " %H:%M:%S" if $with_time;
	my $t; eval{ $t = Time::Piece->strptime($mysql_ts_string, $fmt_in) };

	my $fmt_out = "%d-%m-%Y"; $fmt_out .= " %H:%M:%S" if $with_time;
	return defined($t) ? $t->strftime($fmt_out) : '-';
}


1;
