package Intern::Diary::Config;

use strict;
use warnings;
use utf8;

use Config::ENV 'INTERN_DIARY_ENV', export => 'config';

common {
};

config default => {
};

config production => {
};

config local => {
    parent('default'),
    db => {
        intern_diary => {
            user     => 'nobody',
            password => 'nobody',
            dsn      => 'dbi:mysql:dbname=intern_diary;host=localhost',
        },
    },
    db_timezone => 'UTC',
};

config test => {
    parent('default'),
    db => {
        intern_diary => {
            user     => 'nobody',
            password => 'nobody',
            dsn      => 'dbi:mysql:dbname=intern_diary_test;host=localhost',
        },
    },
    db_timezone => 'UTC',
};

1;
