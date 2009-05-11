use v6;

use IETF::RFC_Grammar::URI;

grammar URI::Grammar is IETF::RFC_Grammar::URI {
    
    token TOP               {
        ^   [ <scheme> ':' ]?
            [ '//' <authority> ]? <path> [ '?' <query> ]?
            [ '#' <fragment> ]? $
    };

    token authority  { <host> [ ':' <port> ]? };
    token path       { <slash>? [ <chunk>** '/'? ]* };
    token slash      { '/' };

#
# following hangs rakudo (RT #37745 afaik)
# token chunk { <[a..z]>* }; say 'ok' if 'index/' ~~ /[ <chunk> '/'?]*/
#
# so can't just use rfc segment but use small hack of requiring
# at least one char.  Use of ** seperator above makes behavior
# consistent with rfc.
#
    token chunk      { <.pchar> <.segment> }
}

# vim:ft=perl6
