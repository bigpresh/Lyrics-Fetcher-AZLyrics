#!/usr/bin/perl

use strict;
use warnings;


use lib '/home/davidp/dev/scripts/perl/modules/Lyrics-Fetcher-AZLyrics/lib';

require Lyrics::Fetcher::AZLyrics;


#my $lyrics =  Lyrics::Fetcher->fetch(
#    'Death Cab For Cutie', 'What Sarah Said', 'AZLyrics');
    
my $lyrics =  Lyrics::Fetcher::AZLyrics->fetch(
    'Death Cab For Cutie', 'What Sarah Said');
print "lyrics: [$lyrics]\n";


