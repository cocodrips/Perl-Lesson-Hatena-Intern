package Intern::Diary::Model::Entry;

use strict;
use warnings;
use utf8;

use JSON::Types qw();
use Encode qw(decode_utf8);

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
    $self->{_updated} ||= eval {
        Intern::Diary::Util::datetime_from_db($self->{created});
    };
}

sub TO_JSON {
    my ($self) = @_;
    return {
        entry_id    => JSON::Types::number $self->entry_id,
        title       => decode_utf8($self->title),
        body        => decode_utf8($self->body),
        diary_id    => JSON::Types::string $self->diary_id,
        created     => JSON::Types::string $self->created,
        updated     => JSON::Types::string $self->updated,
    };
}

1;
