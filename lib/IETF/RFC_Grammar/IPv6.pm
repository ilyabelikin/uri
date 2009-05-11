use v6;

# Taken/Copied with relatively minor translation to Perl6
# from rfc 2373 (http://www.faqs.org/rfcs/rfc2373.html)

grammar IETF::RFC_Grammar::IPv6 {
    token IPv6address       { <.hexpart> [ ':' IPv4address ]? };
    token IPv4address       {
        <.digit> ** 1..3 '.'
        <.digit> ** 1..3 '.'
        <.digit> ** 1..3 '.'
        <.digit> ** 1..3
    };

    token IPv6prefix        { <.hexpart> '/' <.digit> ** 1..2 };
    
    token hexpart           {   [ <.hexseq> '::' <.hexseq>? ]   |
                                [ '::' <.hexseq>? ]             |
                                <.hexseq>                       };
    token hexseq            { <.hex4> [ ':' <.hex4> ]* };
    token hex4              { <.xdigit> ** 1..4 };
}

# vim:ft=perl6
