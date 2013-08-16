package Intern::Diary::Service::Comment;

use strict;
use warnings;
use utf8;

use Carp;
use DateTime;

sub find_comment_by_id {
    my ($class, $db, $args) = @_;

    my $comment_id = $args->{comment_id} // croak 'name required';

    my $comment = $db->dbh('intern_diary')->select_row_as(q[
        SELECT * FROM comment
        WHERE comment = :comment_id
    ], +{
        comment_id => $comment_id
    }, 'Intern::Diary::Model::Comment');

    $comment;
}

sub get_all_comment_by_entry_id {
    my ($class, $db, $args) = @_;

    my $entry_id = $args->{entry_id} // croak 'name required';

    my $comments = $db->dbh('intern_diary')->select_all_as(q[
        SELECT * FROM comment
        WHERE entry_id = :entry_id
    ], +{
        entry_id => $entry_id
    }, 'Intern::Diary::Model::Comment');

    $comments;
}


sub create {
    my ($class, $db, $args) = @_;
    my $entry_id = $args->{entry_id} // croak 'entry_id required';
    my $comment = $args->{comment} // croak 'comment required';

    $db->dbh('intern_diary')->query(q[
        INSERT INTO comment
        SET entry_id  = :entry_id,
        comment  = :comment,
        created = :created
    ], {
        entry_id    => $entry_id,
        comment     => $comment,
        created => DateTime->now,
    });
}

1;
