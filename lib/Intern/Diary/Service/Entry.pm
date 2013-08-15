package Intern::Diary::Service::Entry;

use strict;
use warnings;
use utf8;

use Carp;
use DateTime;

sub find_entry_by_id {
    my ($class, $db, $args) = @_;

    my $entry_id = $args->{entry_id} // croak 'name required';

    my $entry = $db->dbh('intern_diary')->select_row_as(q[
        SELECT * FROM entry
        WHERE entry_id = :entry_id
    ], +{
        entry_id => $entry_id
    }, 'Intern::Diary::Model::Entry');

    $entry;
}

sub get_all_entries_by_user {
    my ($class, $db, $args) = @_;

    my $user_id = $args->{user_id} // croak 'user_id required';

    my $entries = $db->dbh('intern_diary')->select_all_as(q[
        SELECT * FROM entry
        WHERE user_id = :user_id
    ], +{
        user_id => $user_id
    }, 'Intern::Diary::Model::User');

    return $entries;
}


sub update {
    my ($class, $db, $args) = @_;

    my $title = $args->{title} // croak 'title required';
    my $body = $args->{body} // croak 'body required';
    my $entry_id = $args->{entry_id} // croak 'entry_id required';

    $db->dbh('intern_diary')->query(q[
        UPDATE entry
        SET title   = :title,
        body        = :body
        WHERE entry_id = :entry_id
    ], {
        title       => $title,
        body        => $body,
        entry_id    => $entry_id,
    });

    return $class->find_entry_by_id($db, {entry_id => $entry_id});
}

sub delete_entry {
    my ($class, $db, $args) = @_;
    my $entry_id = $args->{entry_id} // croak 'entry_id required';

    $db->dbh('intern_diary')->query(q[
        DELETE FROM entry
        WHERE entry_id = :entry_id
    ], {
        entry_id    => $entry_id,
    });

    return $class->find_entry_by_id($db, {entry_id => $entry_id});
}

sub create {
    my ($class, $db, $args) = @_;

    my $title = $args->{title} // croak 'title required';
    my $body = $args->{body} // croak 'body required';
    my $user_id = $args->{user_id} // croak 'user_id required';
    my $diary_id = $args->{diary_id} // croak 'diary required';

    $db->dbh('intern_diary')->query(q[
        INSERT INTO entry
        SET title  = :title,
        body = :body,
        user_id = :user_id,
        diary_id = :diary_id,
        created = :created
    ], {
        title       => $title,
        body        => $body,
        user_id     => $user_id,
        diary_id    => $diary_id,
        created     => DateTime::Format::MySQL->format_datetime(DateTime->now)
    });
}

1;
