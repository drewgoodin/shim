package Shim::Post; #post object
use strict;
use warnings;
use Shim::Tools;

sub new {
    my ($class, $id) = @_;
    my $self = bless {}, $class;
    $self->_init($id);
    return $self;
}

sub _init {
    my ($self, $id) = @_;
    $self->{id} = $id;
    my %post_content = Shim::Tools::post_content($id);
    my @body = @{$post_content{body}};
    my $body = Shim::Tools::markdown_line_format(@body);
    my @tags = $self->_tags_for_post();
    $self->{title} = $post_content{title};
    $self->{body}  = $body;
    $self->{tags} = \@tags;
}

sub _tags_for_post {
    my $id = shift->id;
    my @tags;
    local $/ = "\n";
    my @tag_lines = Shim::Tools::read_tag_file();
    for (@tag_lines) {
        push @tags => $1 if $_ =~ /^(\S+).*\b$id/;
    }
    return @tags;
}

sub title { shift->{title} }
sub id    { shift->{id} }
sub body  { shift->{body} }
sub tags  { @{shift->{tags}} }
1;
