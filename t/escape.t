use v6;

# Copied, with minor translation to Perl6, from the escape.t file
# in the CPAN URI distribution

use Test;
plan 8;

use URI::Escape;

ok(1,'We use URI::Escape and we are still alive');

is uri_escape('abcDEF?$%@h&m'), 'abcDEF%3F%24%25%40h%26m',
    'basic ascii escape test';

is uri_escape('|abcå'), '%7Cabc%E5', 'basic latin-1 escape test';

ok not defined uri_escape(Str), 'undef returns undef';

is uri_unescape(no_utf8 => True, '%7C%25abc%E5'), '|%abcå', 'basic latin-1 unescape test';
is uri_unescape('%7C%25abc%C3%A5'), '|%abcå', 'basic utf8 unescape test';

is uri_unescape("%40A%42", "CDE", "F%47++H"), ['@AB', 'CDE', 'FG  H'],
    'unescape list';

eval 'print uri_escape("abc" ~ chr(300))';
ok  ~$! ~~ /^'Can\'t escape \x{012C}, try uri_escape_utf8() some day instead'/,
    'verify unicode limitation'

# vim:ft=perl6
