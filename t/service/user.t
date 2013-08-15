package t::Intern::Diary::Service::User;

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
    require_ok 'Intern::Diary::Service::User';
}

sub find_user_by_name : Test(2) {
    my ($self) = @_;

    my $db = Intern::Diary::DBI::Factory->new;

    subtest 'nameないとき失敗する' => sub {
        dies_ok {
            my $user = Intern::Diary::Service::User->find_user_by_name($db, {
            });
        };
    };

    subtest 'user見つかる' => sub {
        my $created_user = create_user();

        my $user = Intern::Diary::Service::User->find_user_by_name($db, {
            name => $created_user->name,
        });

        ok $user, 'userが引ける';
        isa_ok $user, 'Intern::Diary::Model::User', 'blessされている';
        is $user->name, $created_user->name, 'nameが一致する';
    };
}

__PACKAGE__->runtests;

1;
