use v6-alpha;
use Test;

# L<S29/"List"/"=item grep">

=kwid

built-in grep tests

=cut

plan 29;

my @list = (1 .. 10);

{
    my @result = grep { ($_ % 2) }, @list;
    is(+@result, 5, 'we got a list back');
    is(@result[0], 1, 'got the value we expected');
    is(@result[1], 3, 'got the value we expected');
    is(@result[2], 5, 'got the value we expected');
    is(@result[3], 7, 'got the value we expected');
    is(@result[4], 9, 'got the value we expected');
}

{
    my @result = @list.grep():{ ($_ % 2) };
    is(+@result, 5, 'we got a list back');
    is(@result[0], 1, 'got the value we expected');
    is(@result[1], 3, 'got the value we expected');
    is(@result[2], 5, 'got the value we expected');
    is(@result[3], 7, 'got the value we expected');
    is(@result[4], 9, 'got the value we expected');
}

{
    my @result = @list.grep:{ ($_ % 2) };
    is(+@result, 5, 'we got a list back');
    is(@result[0], 1, 'got the value we expected');
    is(@result[1], 3, 'got the value we expected');
    is(@result[2], 5, 'got the value we expected');
    is(@result[3], 7, 'got the value we expected');
    is(@result[4], 9, 'got the value we expected');
}

{
    my @result = grep { ($_ % 2) }: @list;
    is(+@result, 5, 'we got a list back'); 
    is(@result[0], 1, 'got the value we expected'); 
    is(@result[1], 3, 'got the value we expected'); 
    is(@result[2], 5, 'got the value we expected'); 
    is(@result[3], 7, 'got the value we expected'); 
    is(@result[4], 9, 'got the value we expected'); 
}

# .grep shouldn't work on non-arrays
{
  dies_ok { 42.grep:{ $_ } },    "method form of grep should not work on numbers", :todo<bug>;
  dies_ok { "str".grep:{ $_ } }, "method form of grep should not work on strings", :todo<bug>;
  is ~(42,).grep:{ 1 }, "42",    "method form of grep should work on arrays";
}

#
# Grep with mutating block
#

# Dubious: According to S29's definition, neither map nor grep allows for
# mutation.  On the other hand, it seems useful to preserve the bugward
# behaviour.  Marking :todo<unspecced>, pending p6l discussion (see thread
# "[S29] Mutating map and grep" on p6l started by Ingo Blechschmidt
# L<"http://www.nntp.perl.org/group/perl.perl6.language/22553">) and S29 patch.

#?rakudo: todo 'unspecced'
{
  my @array = <a b c d>;
  is ~(try { @array.grep:{ $_ ~= "c"; 1 } }), "ac bc cc dc",
    'mutating $_ in grep works (1)';
  is ~@array, "ac bc cc dc",
    'mutating $_ in grep works (2)';
}

