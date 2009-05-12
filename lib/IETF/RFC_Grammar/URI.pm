use v6;

# Taken/Copied with relatively minor translation to Perl6
# from rfc 2369 (http://www.ietf.org/rfc/rfc2396.txt)

use IETF::RFC_Grammar::IPv6;

grammar IETF::RFC_Grammar::URI is IETF::RFC_Grammar::IPv6 {
    token URI-reference     {
        [ <.absoluteURI> | <.relativeURI> ]? [ '#' <fragment> ]?
    };
    token absoluteURI       { <scheme> ':' [ <.hier_part> | <.opaque_part> ] };
    token relativeURI       {
        [ <.net_path> | <.abs_path> | <.rel_path> ] [ '?' <.query> ]?
    };
    
    token hier_part         { [ <.net_path> | <.abs_path> ] [ '?' <.query> ] };
    token opaque_part       { <.uric_no_slash> <.uric>* };

    token uric_no_slash     { <[;?:@&=+$,] +unreserved +escape> };

    token net_path          { '//' <.authority> <.abs_path>? };
    token abs_path          { '/' <.path_segments> };
    token rel_path          { <.rel_segment> <.abs_path>? };

    token rel_segment       { <[;@&=+$,] +unreserved +escaped>+ };

    token scheme            { <.uri_alpha> <[\-+.] +uri_alpha +digit>* };

    token authority         { <.server> | <.reg_name> };

    token reg_name          { <[$,;:@&=+] +unreserved +escaped>+ };

    token server            { [ [ userinfo '@' ]? hostport ]? };
    token userinfo          { <[;:&=+$,] +unreserved +escaped> };
    
    token hostport          { <host> [ ':' <port> ]? };
    
    token host              { <hostname> | <IPv4address> | <IPv6reference> };
    token ipv6reference     { '[' <IPv6address>  ']'}
    regex hostname          { [ <.domainlabel> '.' ] * <.toplabel> '.'? };
    regex domainlabel       {
        [ <.uri_alphanum> <[\-] +uri_alphanum>* <.uri_alphanum> ] |        
        <.uri_alphanum>
    };
    regex toplabel          {
        [ <.uri_alpha> <[\-] +uri_alphanum>* <.uri_alphanum> ] |        
        <.uri_alpha>
    };
    
    token port              { <.digit>* };

    token path              { [ abs_path | opaque_part ]? };

    token path_segments     { <.segment> [ '/' <.segment> ] * };
    
    token segment           { <.pchar>* [ ';' <.param>]* };
    token param             { <.pchar>* };
    token pchar             { <[:@&=+$,] +unreserved> | <.escaped> };

    token query             { <.uric>* };
    token fragment          { <.uric>* };

    token uric              { <+reserved +unreserved> | <.escaped> };
    token reserved          { <[;/?:@&=+$,\[\]]> };
    token unwise            { <[{}|\\^`]> };

    token unreserved        { <+uri_alphanum +mark> };
    token mark              { <[\-_.!~*'()]> };

    token escaped           { '%' <.xdigit> <.xdigit> };

    token uri_alphanum      { <+uri_alpha +digit> };
    token uri_alpha         { <+lowalpha +upalpha> };

    token lowalpha          { <[a..z]> };
    token upalpha           { <[A..Z]> };
}

# vim:ft=perl6
