use v6;

package URI::Escape {

    use IETF::RFC_Grammar::URI;

    my %escapes = (^256).map: {
        ;
        .chr => sprintf '%%%02X', $_
    };

    # in moving from RFC 2396 to RFC 3986 this selection of characters
    # may be due for an update ...

    # commented line below used to work ...
#    token artifact_unreserved {<[!*'()] +IETF::RFC_Grammar::URI::unreserved>};

    sub uri_escape($s, Bool :$no_utf8 = False) is export {
        return $s unless defined $s;
        $s.subst(:g, rx/<- [!*'()\-._~A..Za..z0..9]>/,
            {
                ( $no_utf8 || ! 0x80 +& ord(.Str) ) ?? %escapes{ .Str } !!
                    %escapes{.Str.encode.list>>.chr}.join;
            }
        );
    }

    # todo - automatic invalid UTF-8 detection
    # see http://www.w3.org/International/questions/qa-forms-utf-8
    #     find first sequence of %[89ABCDEF]<.xdigit>
    #         use algorithm from url to determine if it's valid UTF-8
    sub uri_unescape(*@to_unesc, Bool :$no_utf8 = False) is export {

        my @rc = @to_unesc.map: {
            .trans('+' => ' ')\
            .subst(:g, / '%' (<.xdigit> ** 2 ) /, -> $/ {
                :16(~$0).chr;
            })
        }
        @rc.=map(*.encode('latin-1').decode('UTF-8')) unless $no_utf8;
        return do given @rc.elems { # this might be simplified some day
            when 0 { Nil }
            when 1 { @rc[0] }
            default { @rc }
        }
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
