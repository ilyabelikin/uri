#
# Test URI capabilities needed for the LWP::Simple parse_url() method
#
 
use v6;
use Test;

use URI;

my @test = (
    'Simple URL without path',
        'http://www.rakudo.org',
        ['http', 'www.rakudo.org', 80, ''],

    'Port other than 80',
        'http://www.altavista.com:81/',
        ['http', 'www.altavista.com', 81, '/'],

    'HTTPS scheme, and default port != 80',
        'https://www.rakudo.org/rakudo-latest.tar.bz2',
        ['https', 'www.rakudo.org', 443, '/rakudo-latest.tar.bz2'],

    '#GH-1 http://github.com/cosimo/perl6-lwp-simple/issues/#issue/1',
        'http://www.c64.com/path/with/multiple/slashes/',
        ['http', 'www.c64.com', 80, '/path/with/multiple/slashes/'],

    'FTP url',
        'ftp://get.opera.com/pub/opera/win/1054/en/Opera_1054_en_Setup.exe',
        ['ftp', 'get.opera.com', 21, '/pub/opera/win/1054/en/Opera_1054_en_Setup.exe'],

    'HTTP URL with double-slashes',
        'http://tinyurl.com/api-create.php?url=http://digg.com',
        ['http', 'tinyurl.com', 80, '/api-create.php?url=http://digg.com'],

);

for @test -> $test, $url, $results {
	my $u = URI.new($url);
    is($u.scheme, $results.[0], "Scheme for $url is $results.[0]");
    is($u.host, $results.[1], "Hostname for $url is $results.[1]");
    is($u.port, $results.[2], "Port for $url is $results.[2]");
    is($u.path_query, $results.[3], "Path for $url is $results.[3]");
}

# Check that port is returned as a number,
# or IO::Socket::INET.open() fails
my $port = URI.new('http:5984//localhost/foo/test/').port;
say $port;
is($port.WHAT, 'Int()', 'port is returned as a Int, to avoid problems on sock.open()');

done;


