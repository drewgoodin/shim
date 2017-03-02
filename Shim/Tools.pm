package Shim::Tools;
use Shim::Post;
use strict;
use warnings;
our @EXPORT = qw!fetch_posts extract_title posts_with_tags!;

sub fetch_posts {
    my @posts = @_;
    my @post_objs;
    if (@posts) {
        if ($posts[0] eq "no posts") {
            return ();
        }
    }
    else {
        my $dir = $ENV{DOCUMENT_ROOT} . qq?/nowrap/posts/?;
        opendir (my $dh, $dir);
        @posts = grep { /^[0-9]+$/ } readdir $dh;
    }
    @post_objs = map { Shim::Post->new($_) } @posts;
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

sub posts_with_tags {
    my @tags = @_;
    my @post_list_per_tag;
    my @posts_with_tags;
    open my $fh, '<', $ENV{DOCUMENT_ROOT} . qq?/nowrap/tags?;
    my @lines = <$fh>;
    for my $tag (@tags) {
       for my $line (@lines) { 
        if ($line =~ /^$tag (.*)$/) {
            @post_list_per_tag = split / / => $1;
            push @posts_with_tags => @post_list_per_tag;
        }
       }
    }
    my %posts_with_tags = map { $_ => 1 } @posts_with_tags;
    my @unique_posts = keys %posts_with_tags;
    @unique_posts ? return @unique_posts: return "no posts";
}
1;

