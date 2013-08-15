package t::Intern::Diary::Model::Comment;

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
    use_ok 'Intern::Diary::Model::Comment';
}

sub _accessor : Test(5) {
    my $now = DateTime->now;
    my $comment = Intern::Diary::Model::Comment->new(
        comment_id => 1,
        entry_id => 2,
        user_id => 3,
        comment => 'comment',
        created => DateTime::Format::MySQL->format_datetime($now),
    );
    is $comment->comment_id, 1;
    is $comment->entry_id, 2;
    is $comment->user_id, 3;
    is $comment->comment, 'comment';
    is $comment->created->epoch, $now->epoch;
}


__PACKAGE__->runtests;

1;
