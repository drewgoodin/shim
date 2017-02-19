package Shim::Post; #post object
use strict;
use warnings;
use Shim::Tools;

sub new {
    my $class = shift;
    my $id = shift;
    return bless { title => Shim::Tools::extract_title($id), id => $id }, $class;
    }

sub title { shift->{title} };
sub id    { shift->{id} };
1;
