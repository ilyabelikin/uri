class URI;

has $.uri;
has $!path;
has Bool $!is_absolute is ro;
has $!scheme;
has $!authority;
has $!query;
has $!frag;
has @.chunks;

method init ($str) {
    use IETF::RFC_Grammar::URI;

    # clear string before parsing
    my $c_str = $str;
    $c_str .= subst(/^ \s* ['<' | '"'] /, '');
    $c_str .= subst(/ ['>' | '"'] \s* $/, '');

    IETF::RFC_Grammar::URI.parse($c_str);
    unless $/ { die "Could not parse URI: $str" }

    $!uri = $!path = $!is_absolute = $!scheme = $!authority = $!query =
        $!frag = Mu;
    @!chunks = Nil;

    $!uri = $/;

    my $comp_container = $/<URI_reference><URI> // $/<URI_reference><relative_ref>;
    $!scheme = $comp_container<scheme>;
    $!query = $comp_container<query>;
    $!frag = $comp_container<fragment>;
    $comp_container = $comp_container<hier_part> // $comp_container<relative_part>;

    $!authority = $comp_container<authority>;
    $!path =    $comp_container<path_abempty>       //
                $comp_container<path_absolute>      ;
    $!is_absolute = ?($!path // $.scheme);

    $!path //=  $comp_container<path_noscheme>      //
                $comp_container<path_rootless>      ;

    @!chunks = $!path<segment>.list() // ('');
    if my $first_chunk = $!path<segment_nz_nc> // $!path<segment_nz> {
        unshift @!chunks, $first_chunk;
    }
    if @!chunks.elems == 0 {
        @!chunks = ('');
    }
#    @!chunks ||= ('');
}

method scheme {
    return ~$!scheme.lc;
}

method authority {
    return ~$!authority.lc;
}

method host {
    return ($!authority<host> // '').lc;
}

method port {
    item $!authority<port> // '';
}

method path {
    return ~($!path // '').lc;
}

method absolute {
    return $!is_absolute;
}

method relative {
    return ! $.absolute;
}

method query {
    item ~($!query // '');
}
method frag {
    return ~($!frag // '').lc;
}

method fragment { $.frag }

method Str() {
    my $str;
    $str ~= $.scheme if $.scheme;
    $str ~= '://' ~ $.authority if $.authority;
    $str ~= $.path;
    $str ~= '?' ~ $.query if $.query;
    $str ~= '#' ~ $.frag if $.frag;
    return $str; 
}


=begin pod

=head NAME

URI — Uniform Resource Identifiers (absolute and relative) 

=head SYNOPSYS

    use URI;
    my $u = URI.new;
    $u.init('http://her.com/foo/bar?tag=woow#bla');

    my $scheme = $u.scheme;
    my $authority = $u.authority;
    my $host = $u.host;
    my $port = $u.port;
    my $path = $u.path;
    my $query = $u.query;
    my $frag = $u.frag; # or $u.fragment;

    my $is_absolute = $u.absolute;
    my $is_relative = $u.relative;

=end pod


# vim:ft=perl6
