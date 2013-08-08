#!/bin/sh -v

dbname=${1:-intern_diary}

PERL_AUTOINSTALL=--defaultdeps LANG=C cpanm --installdeps --notest . < /dev/null
mysqladmin -uroot create $dbname
mysql -uroot $dbname < db/schema.sql

mysqladmin -uroot create ${dbname}_test
mysql -uroot ${dbname}_test < db/schema.sql
