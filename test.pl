#!/usr/bin/perl

#$Id$

# quick dirty testing for Lyrics::Fetcher::AZLyrics
#
# TODO: turn this into a proper test script with Test::Simple / Test::More

use strict;
use warnings;


use lib '/home/davidp/dev/scripts/perl/modules/Lyrics-Fetcher-AZLyrics/lib';

require Lyrics::Fetcher::AZLyrics;
require Lyrics::Fetcher;

#my $lyrics =  Lyrics::Fetcher->fetch(
#    'Death Cab For Cutie', 'What Sarah Said', 'AZLyrics');

    
my $lyrics =  Lyrics::Fetcher::AZLyrics->fetch(
    'Death Cab For Cutie', 'What Sarah Said');
print "lyrics: [$lyrics]\n";

print "LFE: $Lyrics::Fetcher::Error\n";


$lyrics = Lyrics::Fetcher->fetch(
    'Oasis', "Turn Up The Sun", 'AZLyrics');
print "LFE: $Lyrics::Fetcher::Error\n";
print "Lyrics via Lyrics::Fetcher->fetch() : \n";
print "[$lyrics]";

