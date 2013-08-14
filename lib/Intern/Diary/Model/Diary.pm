package Intern::Diary::Model::Diary;

use strict;
use warnings;
use utf8;

use JSON::Types qw();

use Class::Accessor::Lite (
    ro => [qw(
        diary_id
        name
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

sub TO_JSON {
    my ($self) = @_;

    return {
        user_id => JSON::Types::number $self->user_id,
        name    => JSON::Types::string $self->name,
        created => JSON::Types::string $self->created,
    };
}

1;
