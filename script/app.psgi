use strict;
use warnings;
use utf8;

use lib 'lib';

use Intern::Diary;
use Intern::Diary::Config;

use Path::Class qw(file);
use Plack::Builder;
use Plack::Middleware::AccessLog::Timed;
use Plack::Middleware::Head;
use Plack::Middleware::Runtime;
use Plack::Middleware::Scope::Container;
use Plack::Middleware::Static;

my $app = Intern::Diary->as_psgi;
my $root = config->root;

builder {
    # enable 'ReverseProxy';
    enable 'Runtime';
    enable 'Head';

    if (config->env eq 'production') {
        my $access_log = Path::Class::file($ENV{ACCESS_LOG} || "$root/log/access_log");
        my $error_log  = Path::Class::file($ENV{ERROR_LOG}  || "$root/log/error_log");

        $_->dir->mkpath for $access_log, $error_log;

        my $fh_access = $access_log->open('>>')
            or die "Cannot open >> $access_log: $!";
        my $fh_error  = $error_log->open('>>')
            or die "Cannot open >> $error_log: $!";

        $_->autoflush(1) for $fh_access, $fh_error;

        enable 'AccessLog::Timed', (
            logger => sub {
                print $fh_access @_;
            },
            format => join("\t",
                'time:%t',
                'host:%h',
                'domain:%V',
                'req:%r',
                'status:%>s',
                'size:%b',
                'referer:%{Referer}i',
                'ua:%{User-Agent}i',
                'taken:%D',
                'xgid:%{X-Generated-Id}o',
                'xdispatch:%{X-Dispatch}o',
                'xrev:%{X-Revision}o',
            )
        );

        enable sub {
            my $app = shift;
            sub {
                my $env = shift;
                local $Intern::Diary::Logger::HANDLE = $fh_error;
                return $app->($env);
            };
        };
    }

    enable 'Static', path => qr<^/(?:images|js|css)/>, root => './static/';
    enable 'Static', path => qr<^/favicon\.ico$>,      root => './static/images';

    enable 'Scope::Container';

    $app;
};
