#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;

use Intern::Diary::DBI::Factory;
use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Entry;
use Intern::Diary::Service::Comment;

my $command = shift @ARGV || 'add';

my %HANDLERS = (
    add     => \&add_entry,
    list    => \&list_entries,
    edit    => \&edit_entries,
    delete  => \&delete_entry,
    comment => \&add_comment,
    show    => \&show_entry,
    adduser => \&create_user
);

$ENV{INTERN_DIARY_ENV} = 'local';

my $handler = $HANDLERS{ $command };
my $db = Intern::Diary::DBI::Factory->new();

$handler->(@ARGV);

sub add_entry {
    my $title = shift @_ || 'no title';

    my $user = get_user();
    my $diary = get_diary();

    if (!$user or !$diary) {
        warn "No user / No Diary";
        return;
    }

    print "Please input text (.o.)/ >>\t";

    my $body= do { local $/; <STDIN>; };
    chomp($body);

    Intern::Diary::Service::Entry->create($db, +{ 
        title => $title, 
        user_id => $user->user_id,
        diary_id => $diary->diary_id, 
        body => $body });
    
    print "Add Success!\n";
}

sub list_entries {
    my $diary = get_diary();
    my $entries = Intern::Diary::Service::Entry->get_all_entries_by_diary_id($db, +{ 
        diary_id => $diary->diary_id
    });

    # no entry
    if (!$#$entries) {
        print "no entry";
        return;
    }
    
    print "entry_id\ttitle\t\tbody\n";
    print "--------------------------------------\n";
    for my $entry (@$entries) {
        print $entry->entry_id."\t\t".$entry->title."\t\t".$entry->body."\n";
    }
}

sub edit_entries {
    my $entry_id = shift @_;
    my $entry = Intern::Diary::Service::Entry->find_entry_by_id($db, +{ entry_id => $entry_id });

    print "Edit title?\n";
    chomp(my $title = <STDIN>);
    if (!$title) {
        $title = $entry->title;
    }

    print "Edit Body?\n";
    chomp(my $body = <STDIN>);
    if (!$body) {
        $body = $entry->body;
    }

    $entry = Intern::Diary::Service::Entry->update($db, +{ entry_id => $entry_id, title => $title, body => $body});
    print Dumper $entry;
}

sub delete_entry {
    my $entry_id = shift @_;

    print "Do you want to delete entry ".$entry_id."? (y/n)\n";
    chomp(my $will = <STDIN>);
    if ($will ne "y") {
        print "We don't delete...";
        return;
    }

    Intern::Diary::Service::Entry->delete_entry($db, +{ entry_id => $entry_id});
    list_entries();
}

sub add_comment{
    my $entry_id = shift @_;
    my $user_id = get_user()->user_id;
    if (!$user_id) {
        print "No user. please add entry.";
        return;
    }
    print "please input ".$entry_id. " comment >>";
    chomp(my $comment = <STDIN>);
    if (!$comment) {
        $comment = "comment test";
    }

    Intern::Diary::Service::Comment->create($db, +{ entry_id => $entry_id, user_id => $user_id, comment => $comment });
}

# 記事の内容、コメントの確認
sub show_entry{
    my $entry_id = shift @_;
    my $entry = Intern::Diary::Service::Entry->find_entry_by_id($db, +{ entry_id => $entry_id });
    my $comments = Intern::Diary::Service::Comment->get_all_comments_by_entry_id($db, +{ entry_id => $entry_id});
    
    print "entry_id\tbody\n";
    print "--------------------------------------\n";
    print $entry->entry_id."\t\t".$entry->body."\n\n";

    print "comment\n";
    print "--------------------------------------\n";
    for my $comment (@$comments) {
        print $comment->comment."\n";
    }
}



sub create_diary {
    my $name = 'MyDiary';
    
    my $diary = Intern::Diary::Service::Diary->find_diary_by_name($db, +{ 
        name => $name
        });
    unless ($diary) {
        $diary = Intern::Diary::Service::Diary->create($db, +{ 
            name => $name,
            get_user()->user_id
            });    
    }
}

sub get_diary {
    my $name = 'MyDiary';
    my $diary = Intern::Diary::Service::Diary->find_diary_by_name($db, +{ name => $name });
    return $diary;
}

sub create_user {
    # my $name = $ENV{USER};
    my $name = "nya";

    my $user = undef;
    unless ($user) {
        $user = Intern::Diary::Service::User->create_user($db, +{ name => $name });
    }
}

sub get_user {
    my $name = $ENV{USER};
    my $user = Intern::Diary::Service::User->find_user_by_name($db, +{ name => $name });
    return $user;
}

__END__


