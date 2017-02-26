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
    my %post_content = Shim::Tools::post_content($id);
    my @body = @{$post_content{body}};
    local $/ = "\r\n"; 
    chomp for @body;
    my @body_for_markdown = map { "$_  \n" } @body;
    my $body = join "" => @body_for_markdown;
    $self->{title} = $post_content{title};
    $self->{body}  = $body;
    $self->{id} = $id;
}

sub title { shift->{title} };
sub id    { shift->{id} };
sub body  { shift->{body} };
1;
