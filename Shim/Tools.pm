package Shim::Tools;
use Shim::Post;
use strict;
use warnings;
our @EXPORT = qw!fetch_posts extract_title!;

sub fetch_posts {
    my $dir = $ENV{DOCUMENT_ROOT} . qq?/nowrap/posts/?;
    opendir (my $dh, $dir);
    my @posts = grep { /^[0-9]+$/ } readdir $dh;
    my @post_objs = map { Shim::Post->new($_) } @posts;
    return \@post_objs;
}

sub post_content { #returns list containing title and aref of body lines
    my $id = shift;
    open my $fh, '<', $ENV{DOCUMENT_ROOT} . qq?/nowrap/posts/$id?;
    my @post_lines = <$fh>;
    my $title = shift @post_lines;
    chomp $title;
    return (title => $title, body => \@post_lines);
}

1;

