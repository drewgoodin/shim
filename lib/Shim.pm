package Shim;
use strict;
use warnings;

sub new {
    my ($class, $id) = @_;
    my $self = bless {}, $class;
    $self->_init($id);
    return $self;
}

sub _init {
    my ($self, $id) = @_;
    $self->{id} = $id;
    my %post_content = post_content($id);
    my @body = @{$post_content{body}};
    my $body = markdown_line_format(@body);
    my @tags = $self->_tags_for_post();
    $self->{title} = $post_content{title};
    $self->{body}  = $body;
    $self->{tags} = \@tags;
}

sub _tags_for_post {
    my $id = shift->id;
    my @tags;
    local $/ = "\n";
    my @tag_lines = read_tag_file();
    for (@tag_lines) {
        push @tags => $1 if $_ =~ /^(\S+).*\b$id/;
    }
    return @tags;
}

sub title { shift->{title} }
sub id    { shift->{id} }
sub body  { shift->{body} }
sub tags  { @{shift->{tags}} }

sub fetch_posts {
	my $self = shift;
	my @posts = @_;
	my @post_objs;
	if (@posts) {
		if ($posts[0] eq "no posts") {
			return ();
		}
	}
	else {
		my $dir = qq?components/static/posts/?;
		opendir (my $dh, $dir);
		@posts = grep { /^[0-9]+$/ } readdir $dh;
	}
	@post_objs = map { $self->new($_) } @posts;
	return \@post_objs;
}

sub post_content { #returns list containing title and aref of body lines
    my $id = shift;
    open my $fh, '<', qq?components/static/posts/$id?;
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
    open my $fh, '<', qq?components/static/tags? or die $!;
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
