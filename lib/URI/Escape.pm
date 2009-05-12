use v6;

package URI::Escape {    
    
    use IETF::RFC_Grammar::URI;
    
    our %escapes;
    
    for 0 .. 255 -> $c {  # map broken in module / package ?
        %escapes{ chr($c) } = sprintf "%%%02X", $c
    }

    sub uri_escape($s is copy) is export {
        my $rc;
        while $s {
            if my $not_escape = $s ~~ /^<IETF::RFC_Grammar::URI::unreserved>+/ {
               $rc ~= $not_escape;
               $s.=substr($not_escape.chars);                
            }
            if my $escape = $s ~~ /^<- IETF::RFC_Grammar::URI::unreserved>+/ {
                $rc ~= ($escape.comb().map: {
                    %escapes{ chr(ord($_)) } || # chr(ord()) ??? @#^^!! it works
                    die 'Can\'t escape \\' ~ sprintf('x{%04X}, try uri_escape_utf8() instead',
                        ord($_))
               }).join;                
               $s.=substr($escape.chars);
            }
        }
        
        return $rc;
    }

    sub uri_unescape(*@to_unesc) is export {
        my @rc;
        for @to_unesc -> $s is copy {
            my $rc;
            while my $next_unescape = $s ~~ /.*? '%' (<.xdigit> <.xdigit>)/ {
                $rc ~=  $next_unescape.substr(0, -3) ~
                        chr( :16($next_unescape[0]) );
                $s.=substr($next_unescape.chars); 
            }
            @rc.push( $rc ~ $s );
        }
        return @rc;
    }

}

=begin pod

=head NAME

URI::Escape - Escape and unescape unsafe characters

=head SYNOPSYS

    use URI::Escape;
    
    my $escaped = uri_escape("10% is enough\n");
    my $un_escaped = uri_unescape('10%25%20is%20enough%0A');

=end pod

# vim:ft=perl6
