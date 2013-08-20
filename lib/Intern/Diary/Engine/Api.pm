package Intern::Diary::Engine::Api;

use strict;
use warnings;
use utf8;

use JSON::Types;

use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Entry;
use Intern::Diary::Service::Comment;


sub default {
    my ($class, $c) = @_; 
    $c->html('api/show_entries_by_json.html');
}

sub get_entries_list_by_json {
    my ($class, $c) = @_; 
    my $diary_id = $c->req->parameters->{'diary_id'};
    my $page = $c->req->parameters->{'page'} || 1;
    my $limit = $c->req->parameters->{'limit'} || 3;
    my $offset = ($page - 1) * $limit ;

    my $entries = Intern::Diary::Service::Entry->get_limited_entries_by_diary_id(
        $c->db,{ 
            diary_id => $diary_id,
            limit    => $limit,
            offset   => $offset
         }
    );

    $c->json({
            entries => $entries
        }
    );
}

sub update_entry_by_json {
    my ($class, $c) = @_;
    my $entry_id = $c->req->parameters->{'entry_id'};
    my $title    = $c->req->parameters->{'title'};
    my $body     = $c->req->parameters->{'body'};

    Intern::Diary::Service::Entry->update(
        $c->db, { 
            entry_id => $entry_id,
            title    => $title,
            body     => $body
         }
    );
}

sub create_entry_by_json {
    my ($class, $c) = @_;
    my $diary_id = $c->req->parameters->{'diary_id'};
    my $title    = $c->req->parameters->{'title'};
    my $body     = $c->req->parameters->{'body'};

    warn $title;
    warn $body;

    Intern::Diary::Service::Entry->create(
        $c->db, { 
            diary_id => $diary_id,
            title    => $title,
            body     => $body
         }
    );
    $c->res->redirect("/diary/$diary_id/entry/list/json");
}

1;
