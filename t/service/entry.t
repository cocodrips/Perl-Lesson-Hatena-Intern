package t::Intern::Diary::Service::Eiary;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent qw(Test::Class);

use Test::Intern::Diary;
use Test::Intern::Diary::Factory;

use Test::More;
use Test::Deep;
use Test::Exception;

use String::Random qw(random_regex);

use Intern::Diary::DBI::Factory;

sub _require : Test(startup => 1) {
    my ($self) = @_;
    require_ok 'Intern::Diary::Service::Entry';
}

sub find_diary_by_name : Test(2) {
    my ($self) = @_;

    my $db = Intern::Diary::DBI::Factory->new;

    subtest 'entryないとき失敗する' => sub {
        dies_ok {
            my $diary = Intern::Diary::Service::Entry->find_entry_by_id($db, {
            });
        };
    };

    subtest 'entry見つかる' => sub {
        my $created_entry = create_entry({
            entry_id => 4,
        });

        my $entry = Intern::Diary::Service::Entry->find_entry_by_id($db, {
            id => $created_entry->entry_id,
        });

        ok $entry, 'entryが引ける';
    #     isa_ok $diary, 'Intern::Diary::Model::Diary', 'blessされている';
    #     is $diary->name, $created_diary->name, 'nameが一致する';
    };

}

__PACKAGE__->runtests;

1;
