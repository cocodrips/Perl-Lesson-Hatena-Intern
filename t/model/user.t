package t::Intern::Diary::Model::User;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::Intern::Diary;

use Test::More;

use parent 'Test::Class';

sub _use : Test(startup => 1) {
    my ($self) = @_;
    use_ok 'Intern::Diary::Model::User';
}

__PACKAGE__->runtests;

1;
