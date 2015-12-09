use strict;
use warnings;
use 5.010001;
use File::HomeDir::Test;
use File::HomeDir;
use Test::More tests => 2;
use Test::Mojo;
use Path::Class::Dir;
use YAML qw( DumpFile );

delete $ENV{HARNESS_ACTIVE};
$ENV{LOG_LEVEL} = "TRACE";

my $etc = Path::Class::Dir
  ->new(File::HomeDir->my_home)
  ->subdir('etc');
$etc->mkpath(0, 0700);

DumpFile($etc->file('PlugAuth.conf')->stringify, {
  plugins => [
    { 'PlugAuth::Plugin::WebUI' => { test => 1} },
  ],
});

my $t = Test::Mojo->new("PlugAuth");

$t->get_ok("/t")
  ->status_is(200);
