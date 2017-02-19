package Shim::Tools;
use Shim::Post;
use strict;
use warnings;
our @EXPORT = qw!fetch_posts extract_title!;

sub fetch_posts {
    my $dir = $ENV{DOCUMENT_ROOT} . qq?/posts/?;
    opendir my $dh, $dir;
    my @posts = grep { /^[0-9]+$/ } readdir $dh;
    my @post_objs = map { Shim::Post->new($_) } @posts;
    return \@post_objs;
}

sub extract_title {
    my $id = shift;
    open my $fh, '<', $ENV{DOCUMENT_ROOT} . qq?/posts/$id?;
    while (<$fh>) {
        if ( /<title>(.+)<\/title>/ ) {
    return $1;
}
}
}

1;

