package Intern::Diary::Engine::Api;

use strict;
use warnings;
use utf8;

use JSON::Types;

use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Entry;
use Intern::Diary::Service::Comment;

sub get_entries_list_by_json{
    my ($class, $c) = @_; 
    my $diary_id = $c->req->parameters->{'diary_id'};

    my $entries = Intern::Diary::Service::Entry->get_all_entries_by_diary_id(
        $c->db,{ 
            diary_id => $diary_id
         }
    );

    use Data::Dumper; warn Dumper $entries;
    $c->json({
            entries => $entries
        }
    );

}

1;
