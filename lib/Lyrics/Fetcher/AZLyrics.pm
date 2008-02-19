package Lyrics::Fetcher::AZLyrics;

# $Id$

use 5.008000;
use strict;
use warnings;
use LWP::UserAgent;
use HTML::TokeParser;
use Carp;

our $VERSION = '0.03';

# the HTTP User-Agent we'll send:
our $AGENT = "Perl/Lyrics::Fetcher::AZLyrics $VERSION";

    

sub fetch {
    
    my $self = shift;
    my ( $artist, $song ) = @_;
    
    # reset the error var, change it if an error occurs.
    $Lyrics::Fetcher::Error = 'OK';
    
    unless ($artist && $song) {
        carp($Lyrics::Fetcher::Error = 
            'fetch() called without artist and song');
        return;
    }
    
    $artist =~ s/[^a-z0-9]//gi;
    $song   =~ s/[^a-z0-9]//gi;
    
    my $url = 'http://www.azlyrics.com/lyrics/';
    $url .= join('/', lc $artist, lc $song) . '.html';
    
    my $ua = new LWP::UserAgent;
    $ua->timeout(6);
    $ua->agent($AGENT);
    my $res = $ua->get($url);
    if ( $res->is_success ) {
        my $lyrics = _parse($res->content);
        return $lyrics;
    } else {
    
        if ($res->status_line =~ /^404/) {
            $Lyrics::Fetcher::Error = 
                'Lyrics not found';
            return;
        } else {
            carp($Lyrics::Fetcher::Error = 
                "Failed to retrieve $url (".$res->status_line.')');
            return;
        }
    }


}


sub _parse {
    
    my $html = shift;
    my $tp = HTML::TokeParser->new(\$html);
    #my $text = $tp->get_trimmed_text();
    
    
    # the HTML on the pages returned by azlyrics.com is rather nasty, so we
    # have to do dirty tricks to parse it.  We'll find all <font> tags, and read
    # from there until the </font> tag.  If what we got looks vaguely suitable,
    # we then need to trim it a little.
    while (my $wotsit = $tp->get_tag('font')) {
        
        # get the text up to the next </font> tag
        my $text = $tp->get_text('/font');
        
        if (length $text > 20) {
            # this might well be it.  We'll clean it up and do some checks on
            # it in the process.
            
            $text =~ s/\r//mg;
            
            # the page title should look like "<ARTIST> LYRICS" on a line
            # by itself:
            unless ($text =~ s/^.*LYRICS \n?//xgs) {
                carp("No page title found, this HTML doesn't look right");
                return;
            }
           
            
            unless ($text =~ s/\[ \s www\.azlyrics\.com \s \]//xmg) {
                carp("No azlyrics.com line found");
                return;
            }
            
            # song title should be on a line that starts and ends with double
            # quotes, strip it out
            unless ($text =~ s/" .+ "//xmg) {
                carp("No song title found, this HTML doesn't look right");
                return;
            }
            
            # some lyrics pages have credits at the bottom for the submitter...
            # remove them from the lyrics, but store them in case they're
            # wanted:
            my @credits;
            while ($text =~ s{\[ Thanks \s to \s (.+) \]}{}xgi) {
                push @credits, $1;
            }
            
            # bodge... do this twice, to avoid the '... used only once' warning
            @Lyrics::Fetcher::azcredits = @credits;
            @Lyrics::Fetcher::azcredits = @credits;
            
            # finally, clear up excess blank lines:
            while ($text =~ s/\n{2,}/\n/gs) {};

            
            
            return $text;
            
        }
        
    
    
    }
    
} # end of sub parse



1;
__END__

=head1 NAME

Lyrics::Fetcher::AZLyrics - Get song lyrics from www.azlyrics.com

=head1 SYNOPSIS

  use Lyrics::Fetcher;
  print Lyrics::Fetcher->fetch("<artist>","<song>","AZLyrics");

  # or, if you want to use this module directly without Lyrics::Fetcher's
  # involvement:
  use Lyrics::Fetcher::AZLyrics;
  print Lyrics::Fetcher::AZLyrics->fetch('<artist>', '<song>');


=head1 DESCRIPTION

This module tries to get song lyrics from www.azlyrics.com.  It's designed to
be called by Lyrics::Fetcher, but can be used directly if you'd prefer.

=head1 INTERFACE

=over 4

=item fetch($artist, $title)

Attempts to fetch lyrics.

=back


=head1 BUGS

Probably.  If you find any, please let me know.  If azlyrics.com change their
site much, this module may well stop working.  If you find any songs which
have lyrics listed on the www.azlyrics.com site, but for which this module is
unable to fetch lyrics, please let me know also.  It seems that the HTML on
the lyrics pages isn't consistent, so it's entirely possible (likely, in fact)
that there are some pages which this script will not be able to parse.


=head1 COPYRIGHT

This program is free software; you can redistribute it and/or modify it under 
the same terms as Perl itself.


=head1 AUTHOR

David Precious E<lt>davidp@preshweb.co.ukE<gt>



=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007-08 by David Precious

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.

Legal disclaimer: I have no connection with the owners of www.azlyrics.com.
Lyrics fetched by this script may be copyrighted by the authors, it's up to 
you to determine whether this is the case, and if so, whether you are entitled 
to request/use those lyrics.  You will almost certainly not be allowed to use
the lyrics obtained for any commercial purposes.

=cut
