use v6;
use Test;

use lib 't/spec/packages';
use Test::Util;

plan 10;

sub create-temporary-file {
    my $filename = $*TMPDIR ~ '/tmp.' ~ $*PID ~ '-' ~ time;
    return $filename, open($filename, :w);
}

my ( $tmp-file-name, $tmp-file-handle ) = create-temporary-file;
my $output;
my @lines;

$tmp-file-handle.say: 'one';
$tmp-file-handle.say: 'two';
$tmp-file-handle.say: 'three';

$tmp-file-handle.close;

my @args = $tmp-file-name;

$output = Test::Util::run('say get()', :@args);

is $output, "one\n", 'get() should read from $*ARGFILES, which reads from files in @*ARGS';

$output = Test::Util::run('say get()', "foo\nbar\nbaz\n");

is $output, "foo\n", 'get($*ARGFILES) reads from $*IN if no files are in @*ARGS';

$output = Test::Util::run('while get() -> $line { say $line }', :@args);
@lines  = lines($output);

is-deeply @lines, [<one two three>], 'calling get() several times should work';

$output = Test::Util::run('while get() -> $line { say $line }', "foo\nbar\nbaz\n", :@args);
@lines  = lines($output);

is-deeply @lines, [<one two three>], '$*ARGFILES should not use $*IN if files are in @*ARGS';

$output = Test::Util::run('.say for lines()', :@args);
@lines  = lines($output);

is-deeply @lines, [<one two three>], 'lines() should read from $*ARGFILES, which reads from files in @*ARGS';

$output = Test::Util::run('.say for lines()', "foo\nbar\nbaz\n");
@lines  = lines($output);

is-deeply @lines, [<foo bar baz>], 'lines($*ARGFILES) reads from $*IN if no files are in @*ARGS';

$output = Test::Util::run('.say for lines()', "foo\nbar\nbaz\n", :args(['-']));
@lines  = lines($output);

is-deeply @lines, [<foo bar baz>], 'lines($*ARGFILES) reads from $*IN if - is in @*ARGS';

$output = Test::Util::run('.say for lines()', "foo\nbar\nbaz\n", :@args);
@lines  = lines($output);

is-deeply @lines, [<one two three>], '$*ARGFILES should not use $*IN if files are in @*ARGS';

$output = Test::Util::run('.say for lines(); .say for lines()', "foo\nbar\nbaz\n", :@args);
@lines  = lines($output);

# RT #125380
is-deeply @lines, [<one two three>], 'Calling lines() twice should not read from $*IN';

$output = Test::Util::run("@*ARGS = '$tmp-file-name'; .say for lines()", "foo\nbar\nbaz\n");
@lines  = lines($output);

is-deeply @lines, [<one two three>], 'Changing @*ARGS before calling things on $*ARGFILES should open the new file';

$tmp-file-name.IO.unlink;
