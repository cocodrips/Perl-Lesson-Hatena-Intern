package t::Intern::Diary::Model::Entry;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::Intern::Diary;

use Test::More;

use parent 'Test::Class';

use DateTime;
use DateTime::Format::MySQL;

use JSON::XS;

sub _use : Test(startup => 1) {
    my ($self) = @_;
    use_ok 'Intern::Diary::Model::Entry';
}

sub _accessor : Test(6) {
    my $now = DateTime->now;
    my $entry = Intern::Diary::Model::Entry->new(
        entry_id => 1,
        title => 'title',
        diary_id    => 3,
        body    => 'body',
        created => DateTime::Format::MySQL->format_datetime($now),
    );
    is $entry->entry_id, 1;
    is $entry->title, 'title';
    is $entry->diary_id, 3;
    is $entry->body, 'body';
    is $entry->created->epoch, $now->epoch;
}


__PACKAGE__->runtests;

1;
