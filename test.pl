#!/usr/bin/perl

#$Id$

# quick dirty testing for Lyrics::Fetcher::AZLyrics
#
# TODO: turn this into a proper test script with Test::Simple / Test::More

use strict;
use warnings;


use lib '/home/davidp/dev/scripts/perl/modules/Lyrics-Fetcher-AZLyrics/lib';

require Lyrics::Fetcher::AZLyrics;


#my $lyrics =  Lyrics::Fetcher->fetch(
#    'Death Cab For Cutie', 'What Sarah Said', 'AZLyrics');

# should fail:
my $lyrics = Lyrics::Fetcher::AZLyrics->fetch();

print "LFE: $Lyrics::Fetcher::Error\n";
    
$lyrics =  Lyrics::Fetcher::AZLyrics->fetch(
    'Death Cab For Cutie', 'What Sarah Said');
print "lyrics: [$lyrics]\n";

print "LFE: $Lyrics::Fetcher::Error\n";


$lyrics =  Lyrics::Fetcher::AZLyrics->fetch(
    'Death Cab For Cutie', 'What Your Mum Said');
print "lyrics: [$lyrics]\n";

print "LFE: $Lyrics::Fetcher::Error\n";
