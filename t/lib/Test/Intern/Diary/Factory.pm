# テスト用メソッド全部ここにかく
package Test::Intern::Diary::Factory;

use strict;
use warnings;
use utf8;

use Exporter::Lite;
# 生の名前で呼べる
our @EXPORT = qw(
    create_user
    create_entry
    create_diary
);

use String::Random qw(random_regex);
use DateTime;
use DateTime::Format::MySQL;

use Intern::Diary::Service::User;
use Intern::Diary::Service::Entry;
use Intern::Diary::Service::Diary;

sub create_user {
    my %args = @_;
    my $name = $args{name} // random_regex('test_user_\w{15}');
    my $created = $args{created} // DateTime->now;

    my $db = Intern::Diary::DBI::Factory->new;
    my $dbh = $db->dbh('intern_diary');
    $dbh->query(q[
        INSERT INTO user
        SET name = :name,
        created = :created
    ], {
        name    => $name,
        created => DateTime::Format::MySQL->format_datetime($created),
    });

    return Intern::Diary::Service::User->find_user_by_name($db, { name => $name });
}

sub create_diary {
    my %args = @_;
    my $name = $args{name} // random_regex('test_diary_\w{15}');
    my $created = $args{created} // DateTime->now;

    my $db = Intern::Diary::DBI::Factory->new;
    my $dbh = $db->dbh('intern_diary');
    $dbh->query(q[
        INSERT INTO diary
        SET name = :name,
        created = :created
    ], {
        name    => $name,
        created => DateTime::Format::MySQL->format_datetime($created),
    });

    return Intern::Diary::Service::Diary->find_diary_by_name($db, { name => $name });
}

sub create_entry {
    my %args = @_;
    my $entry_id = $args{entry_id};
    my $title = $args{title} // random_regex('test_entry_\w{15}');
    my $body = $args{body} // random_regex('test_body_\w{15}');
    my $diary_id = $args{diary_id} // 1;
    my $user_id = $args{diary_id} // 1;
    my $created = $args{created} // DateTime->now;

    my $db = Intern::Diary::DBI::Factory->new;
    my $dbh = $db->dbh('intern_diary');
    $dbh->query(q[
        INSERT INTO entry
        SET title  = :title,
        body = :body,
        entry_id = :entry_id,
        user_id = :user_id,
        diary_id = :diary_id,
        created = :created
    ], {
        title       => $title,
        body        => $body,
        entry_id    => $entry_id,
        user_id     => $user_id,
        diary_id    => $diary_id,
        created     => DateTime::Format::MySQL->format_datetime(DateTime->now)
    });

    return Intern::Diary::Service::Entry->find_entry_by_id($db, { id => $entry_id });
}
1;
