package Intern::Diary::Model::Entry;

use strict;
use warnings;
use utf8;

use JSON::Types qw();

use Class::Accessor::Lite (
    ro => [qw(
        entry_id
        title
        diary_id
        body
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

sub updated {
    my ($self) = @_;
    $self->{_created} ||= eval {
        Intern::Diary::Util::datetime_from_db($self->{created});
    };
}


1;
