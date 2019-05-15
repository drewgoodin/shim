package Shim::Tools;
use Shim::Post;
use strict;
use warnings;
use Exporter qw!import!;
our @EXPORT = qw!fetch_posts extract_title posts_with_tag read_tag_file markdown_line_format!;

sub fetch_posts {
    my @posts = @_;
    my @post_objs;
    if (@posts) {
        if ($posts[0] eq "no posts") {
            return ();
        }
    }
    else {
        my $dir = qq?components/nowrap/posts/?;
        opendir (my $dh, $dir);
        @posts = grep { /^[0-9]+$/ } readdir $dh;
    }
    @post_objs = map { Shim::Post->new($_) } @posts;
    return \@post_objs;
}

sub post_content { #returns list containing title and aref of body lines
    my $id = shift;
    open my $fh, '<', qq?components/nowrap/posts/$id?;
    my @post_lines = <$fh>;
    my $title = shift @post_lines;
    chomp $title;
    return (title => $title, body => \@post_lines);
}

sub posts_with_tag {
    my $tag = shift;
    my @post_list_per_tag;
    my @posts_with_tag;
    my @lines = read_tag_file(); 
    for my $line (@lines) { 
      if ($line =~ /^$tag (.*)$/) {
        @post_list_per_tag = split / / => $1;
        push @posts_with_tag => @post_list_per_tag;
      }
     }
    my %posts_with_tag = map { $_ => 1 } @posts_with_tag;
    my @unique_posts = keys %posts_with_tag;
    @unique_posts ? return @unique_posts: return "no posts";
}

sub read_tag_file {
    open my $fh, '<', qq?components/nowrap/tags? or die $!;
    chomp(my @lines = <$fh>);
    close $fh;
    return @lines;
}

sub markdown_line_format {
    my @lines = @_;
    local $/ = "\r\n"; 
    chomp @lines;
    my @text_for_markdown = map {  "$_\n" } @lines;
    my $text = join "" => @text_for_markdown;
    return $text;
}
1;
