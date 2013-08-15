package t::Intern::Diary::Model::Diary;

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
    use_ok 'Intern::Diary::Model::Diary';
}

sub _accessor : Test(3) {
    my $now = DateTime->now;
    my $entry = Intern::Diary::Model::Diary->new(
        diary_id => 1,
        name => 'name',
        created => DateTime::Format::MySQL->format_datetime($now),
    );
    is $entry->diary_id, 1;
    is $entry->name, 'name';
    is $entry->created->epoch, $now->epoch;
}


__PACKAGE__->runtests;

1;
