use v6;
use Test;
plan 22;


# L<S32::Containers/Buf>

ok 'ab'.encode('ASCII') ~~ blob8, '$str.encode returns a blob8';
ok ('ab'.encode('ASCII') eqv blob8.new(97, 98)),  'encoding to ASCII';
is 'ab'.encode('ASCII').elems, 2, 'right length of Buf';
ok ('ö'.encode('UTF-8') eqv utf8.new(195, 182)), 'encoding to UTF-8';
is 'ab'.encode('UTF-8').elems, 2, 'right length of Buf';
is 'ö'.encode('UTF-8')[0], 195, 'indexing a utf8 gives correct value (1)';
is 'ö'.encode('UTF-8')[1], 182, 'indexing a utf8 gives correct value (1)';

is 'abc'.encode()[0], 97, 'can index one element in a Buf';
is_deeply 'abc'.encode()[1, 2], (98, 99), 'can slice-index a Buf';

# verified with Perl 5:
# perl -CS -Mutf8 -MUnicode::Normalize -e 'print NFD("ä")' | hexdump -C
#?rakudo skip 'We do not handle NDF yet'
ok ('ä'.encode('UTF-8', 'D') eqv Buf.new(:16<61>, :16<cc>, :16<88>)),
                'encoding to UTF-8, with NFD';

ok ('ä'.encode('UTF-8') eqv utf8.new(:16<c3>, :16<a4>)),
                'encoding ä utf8 gives correct numbers';

ok Buf.new(195, 182).decode ~~ Str, '.decode returns a Str';
is Buf.new(195, 182).decode, 'ö', 'decoding a Buf with UTF-8';
is Buf.new(246).decode('ISO-8859-1'), 'ö', 'decoding a Buf with Latin-1';

ok Buf ~~ Stringy, 'Buf does Stringy';
ok Buf ~~ Positional, 'Buf does Positional';

is 'abc'.encode('ascii').list.join(','), '97,98,99', 'Buf.list gives list of codepoints';

{
    my $temp;

    ok $temp = "\x1F63E".encode('UTF-16'), 'encode a string to UTF-16 surrogate pair';
    ok $temp = utf16.new($temp),           'creating utf16 Buf from a surrogate pair';
    is $temp[0], 0xD83D,                   'indexing a utf16 gives correct value';
    is $temp[1], 0xDE3E,                   'indexing a utf16 gives correct value';
    #?rakudo.parrot skip 'VMArray: index out of bounds'
    is $temp.decode(), "\x1F63E",          'decoding utf16 Buf to original value';
}

# vim: ft=perl6
