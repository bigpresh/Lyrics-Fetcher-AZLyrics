package Lyrics::Fetcher::AZLyrics;

# $Id$

use 5.008007;
use strict;
use warnings;
use LWP::UserAgent;

our $VERSION = '0.01';

BEGIN {
    $Lyrics::Fetcher::Error = 'OK';
}
    

sub fetch {
    
    my $self = shift;
    my ( $artist, $song ) = @_;
    
    
    $artist =~ s/[^a-z0-9]//gi;
    $song   =~ s/[^a-z0-9]//gi;
    
    my $url = 'http://www.azlyrics.com/lyrics/';
    $url .= join('/', lc $artist, lc $song) . '.html';
    
    my $ua = new LWP::UserAgent;
    $ua->timeout(6);
    $ua->agent("Mozilla/5.0");
    my $res = $ua->get($url);
    if ( $res->is_success ) {
        my $lyrics = parse($res->content);
        return $lyrics;
    }


}

# takes the HTML returned by azlyrics.com and attempts to parse out the 
# lyrics.  We have to make some terrible assumptions here on the format of
# the response, if they change their pages, it'll probably break.
sub parse {

    my $html = shift;
    
    my $err = "Failed to parse AZLyrics response";
    
    # split at empty lines:
    my @chunks = split /^[^\S]$/xms, $html;
    
    warn "chunks: " . scalar @chunks;
    
    if (@chunks != 5) {
        warn "$err - wrong number of chunks (got: ".scalar @chunks.")";
        return;
    }
    
    my $lyrics = $chunks[2];
    
    # remove the <br> tags:
    $lyrics =~ s{<br (\s? /)? >}{}xgi;
    
    # remove the credits (in <i> tags), and put them in @credits so we
    # can return them
    my @credits;
    while ($lyrics =~ s{ <i> (.+) </i> }{}xgi) {
        push @credits, $1;
    }
    @Lyrics::Fetcher::azcredits = @credits;
    
    # remove the homepage link:
    $lyrics =~ s/\[ .+ \]//xgi;
    
    # and strip any more HTML:
    $lyrics =~ s/<.*>//xgi;
    
    # condense any sets of 3 or more newlines to 2:
    #$lyrics =~ s/\n{3,}/\n\n/msgi;
    $lyrics =~ s/(\r?\n){3,}/\n\n/gsi;
    
    return $lyrics;


}

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


Blah blah blah.



=head1 BUGS

Probably.  If you find any, please let me know.  If azlyrics.com change their
site much, this module may well stop working.

=head1 COPYRIGHT

This program is free software; you can redistribute it and/or modify it under 
the same terms as Perl itself.


=head1 AUTHOR

David Precious E<lt>davidp@preshweb.co.ukE<gt>



=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by David Precious

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
