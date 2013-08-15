package t::Intern::Diary::Service::Diary;

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
    require_ok 'Intern::Diary::Service::Diary';
}

sub find_diary_by_name : Test(2) {
    my ($self) = @_;

    my $db = Intern::Diary::DBI::Factory->new;

    subtest 'diaryないとき失敗する' => sub {
        dies_ok {
            my $diary = Intern::Diary::Service::Diary->find_diary_by_name($db, {
            });
        };
    };

    subtest 'diary見つかる' => sub {
        my $created_diary = create_diary();

        my $diary = Intern::Diary::Service::Diary->find_diary_by_name($db, {
            name => $created_diary->name,
        });

        ok $diary, 'userが引ける';
        isa_ok $diary, 'Intern::Diary::Model::Diary', 'blessされている';
        is $diary->name, $created_diary->name, 'nameが一致する';
    };

}

__PACKAGE__->runtests;

1;
