package Intern::Diary::Engine::Entry;

use strict;
use warnings;
use utf8;
use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Entry;

sub default {
    my ($class, $c) = @_;
    my $name = $ENV{USER};

    my $user = Intern::Diary::Service::User->find_user_by_name(
        $c->db,
        { name => $name }
    );
    
    $c->html('index.html', {
        name => $user->{'name'}
        }
    );
}

sub entries_list{
    my ($class, $c) = @_; 
    my $params = $c->req->parameters;

    my $name = $ENV{USER};
    my $user = Intern::Diary::Service::User->find_user_by_name(
        $c->db,
        { name => $name }
    );

    my $entries = Intern::Diary::Service::Entry->get_all_entries_by_user(
        $c->db,{ 
            user_id => $user->{'user_id'},
         }
    );

    $c->html('entry/entries_list.html', {
            entries => $entries
        }
    );
}

sub show_entry {
    my ($class, $c) = @_;    
    my $entry_id = $c->req->parameters->{entry_id};

    my $entry = Intern::Diary::Service::Entry->find_entry_by_id(
        $c->db,{ 
            entry_id => $entry_id,
         }
    );

    $c->html('entry/show_entry.html', {
            entry => $entry
        }
    );
}

sub show_entries {
    my ($class, $c) = @_;    
    my $entry_id = $c->req->parameters->{entry_id};
    my $page = $c->req->parameters->{page} // 0;

    my $name = $ENV{USER};
    my $user = Intern::Diary::Service::User->find_user_by_name(
        $c->db,
        { name => $name }
    );
    my $entries;

    if ($page) {
        my $limit = $c->req->parameters->{limit};
        my $offset = ($page - 1) * $limit ;

        $entries = Intern::Diary::Service::Entry->get_limited_entries_by_user(
            $c->db,{ 
                user_id => $user->{'user_id'},
                limit   => $limit,
                offset    => $offset
             }
        );
    } else {
        $entries = Intern::Diary::Service::Entry->get_all_entries_by_user(
            $c->db,{ 
                user_id => $user->{'user_id'},
            }
        );
    }
    $c->html('entry/show_entries.html', {
            entries => $entries,
            page => $page
        }
    );
}

sub update_entry_form {
    my ($class, $c) = @_;    
    my $entry_id = $c->req->parameters->{entry_id};

    my $entry = Intern::Diary::Service::Entry->find_entry_by_id(
        $c->db,{ 
            entry_id => $entry_id,
         }
    );

    $c->html('entry/update_entry.html', {
            entry => $entry
        }
    );
}

sub update_entry {
    my ($class, $c) = @_;    
    my $entry_id = $c->req->parameters->{entry_id};
    my $title = $c->req->parameters->{title};
    my $body = $c->req->parameters->{body};

    my $entry = Intern::Diary::Service::Entry->update(
        $c->db,{ 
            entry_id => $entry_id,
            title => $title,
            body => $body,
         }
    );
    $c->res->redirect("/diary/$entry_id/entries");
}


sub delete_entry {
    my ($class, $c) = @_;    
    my $entry_id = $c->req->parameters->{entry_id};

    my $entry = Intern::Diary::Service::Entry->delete_entry(
        $c->db,{ 
            entry_id => $entry_id,
         }
    );
    $c->res->redirect("/diary/$entry_id/entries");
}

sub create_entry_form {
    my ($class, $c) = @_;    
    my $params = $c->req->parameters;
    $c->html('entry/create_entry.html', {
            params => $params,
        }
    );
}

sub create_entry {
    my ($class, $c) = @_; 

    my $params = $c->req->parameters;

    my $name = $ENV{USER};
    my $user = Intern::Diary::Service::User->find_user_by_name(
        $c->db,
        { name => $name }
    );

    my $diary_id = $c->req->parameters->{diary_id}; 
    my $title = $c->req->parameters->{entry_title}; 
    my $body = $c->req->parameters->{entry_body}; 

    Intern::Diary::Service::Entry->create(
        $c->db,{ 
            user_id => $user->{'user_id'},
            diary_id=> $diary_id,
            title   => $title,
            body    => $body
         }
    );
    
    $c->html('entry/created_entry.html',{
            params => $params,
            title => $title,
            body=> $body
        }
    );
}


1;
__END__
