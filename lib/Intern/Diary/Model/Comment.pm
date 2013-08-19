package Intern::Diary::Model::Comment;

use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
    ro => [qw(
        comment_id
        entry_id 
        comment
    )],
    new => 1,
);

use Intern::Diary::Util;

sub created {
    my ($self) = @_;
    $self->{_created} ||= eval {
        Intern::Diary::Util::datetime_from_db($self->{created});
    };
}

1;
