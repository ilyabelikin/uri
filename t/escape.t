use v6;

# Copied, with minor translation to Perl6, from the escape.t file
# in the CPAN URI distribution

use Test;
plan 7;

use URI::Escape;

ok(1,'We use URI::Escape and we are still alive');

is uri_escape('abcDEF?$%@h&m'), 'abcDEF%3F%24%25%40h%26m',
    'basic ascii escape test';

is uri_escape('|abcå'), '%7Cabc%E5', 'basic latin-1 escape test';

ok not defined uri_escape(undef), 'undef returns undef';

is uri_unescape('%7Cabc%E5'), '|abcå', 'basic latin-1 unescape test';

is uri_unescape("%40A%42", "CDE", "F%47H"), <@AB CDE FGH>,
    'unescape list';

eval 'print uri_escape("abc" ~ chr(300))';
ok  ~$! ~~ /^'Can\'t escape \\x{012C}, try uri_escape_utf8\(\) instead'/,
    'verify unicode limitation'

=begin

# todo tests

print "not " unless uri_escape("abc", "b-d") eq "a%62%63";
print "ok 2\n";

use URI::Escape :escapes;

print "not" unless $escapes{"%"} eq "%25";
print "ok 6\n";

use URI::Escape qw(uri_escape_utf8);

print "not " unless uri_escape_utf8("|abcå") eq "%7Cabc%C3%A5";
print "ok 7\n";

print "not " unless uri_escape_utf8(chr(0xFFF)) eq "%E0%BF%BF";
print "ok 9\n";

=end

# vim:ft=perl6
