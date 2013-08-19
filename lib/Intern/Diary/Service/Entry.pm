package Intern::Diary::Service::Entry;

use strict;
use warnings;
use utf8;

use Carp;
use DateTime::Format::MySQL;

sub find_entry_by_id {
    my ($class, $db, $args) = @_;

    my $entry_id = $args->{entry_id} // croak 'entry_id required';

    my $entry = $db->dbh('intern_diary')->select_row_as(q[
        SELECT * FROM entry
        WHERE entry_id = :entry_id
    ], +{
        entry_id => $entry_id
    }, 'Intern::Diary::Model::Entry');

    $entry;
}

sub get_all_entries_by_diary_id {
    my ($class, $db, $args) = @_;

    my $diary_id = $args->{diary_id} // croak 'diary_id required';

    my $entries = $db->dbh('intern_diary')->select_all_as(q[
        SELECT * FROM entry
        WHERE diary_id = :diary_id 
        ORDER BY created DESC
    ], +{
        diary_id => $diary_id
    }, 'Intern::Diary::Model::Entry');

    return $entries;
}

sub get_limited_entries_by_diary_id {
    my ($class, $db, $args) = @_;

    my $diary_id = $args->{diary_id} // croak 'diary_id required';
    my $limit = $args->{limit} // 3;
    my $offset = $args->{offset} // 1;

    my $entries = $db->dbh('intern_diary')->select_all_as(q[
        SELECT * FROM entry
        WHERE diary_id = :diary_id
        ORDER BY created DESC
        LIMIT :limit 
        OFFSET :offset
    ], +{
        diary_id => $diary_id,
        limit => $limit,
        offset => $offset
    }, 'Intern::Diary::Model::Entry');

    return $entries;
}



sub update {
    my ($class, $db, $args) = @_;

    my $entry_id = $args->{entry_id} // croak 'entry_id required';
    my $title = $args->{title} // croak 'title required';
    my $body = $args->{body} // croak 'body required';

    $db->dbh('intern_diary')->query(q[
        UPDATE entry
        SET title       = :title,
        body            = :body,
        updated         = :updated
        WHERE entry_id  = :entry_id
    ], {
        title       => $title,
        body        => $body,
        updated     => DateTime::Format::MySQL->format_datetime(DateTime->now),
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
    my $diary_id = $args->{diary_id} // croak 'diary required';

    $db->dbh('intern_diary')->query(q[
        INSERT INTO entry
        SET title  = :title,
        body = :body,
        diary_id = :diary_id,
        created = :created
    ], {
        title       => $title,
        body        => $body,
        diary_id    => $diary_id,
        created     => DateTime::Format::MySQL->format_datetime(DateTime->now)
    });
}

1;
