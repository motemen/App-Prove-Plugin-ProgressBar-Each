use strict;
use warnings;
use App::Prove;
use lib 'lib';

my $prove = App::Prove->new;
$prove->process_args('-PProgressBar::Each', @ARGV ? @ARGV : glob 't/samples/*');
$prove->run;
