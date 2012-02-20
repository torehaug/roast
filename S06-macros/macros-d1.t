use v6;

use Test;
plan 6;

# Just to avoid tedium, the macros in this file are
# named after Santa's reindeers.

{ # macro called like a sub
    my $macro_visits;

    macro dasher() {
        $macro_visits++;
        quasi {}
    }

    dasher();
    is $macro_visits, 2, "calls to macro are at parse time";
    dasher();

    my $total_args;
    macro dancer($a, $b?) {
        $total_args++ if defined $a;
        $total_args++ if defined $b;
        quasi {}
    }

    dancer(17);
    is $total_args, 3, "macro call with arguments works";
    dancer(15, 10);
}

{ # macro called like a list prefix
    my $macro_visits;

    macro prancer() {
        $macro_visits++;
        quasi {}
    }

    prancer;
    is $macro_visits, 2, "macro calls without parens work";
    prancer;

    my $total_args;
    macro vixen($a, $b?) {
        $total_args++ if defined $a;
        $total_args++ if defined $b;
        quasi {}
    }

    vixen 17;
    is $total_args, 3, "macro call with arguments works";
    vixen 15, 10;
}

# macro defined as an operator, and used as one

{
    macro infix:<comet>($rhs, $lhs) {
        quasi { "comet!" }
    }

    my $result = 1 comet 2;
    is $result, "comet!", "can define an entirely new operator";
}

{
    macro infix:<+>($rhs, $lhs) {
        quasi { "chickpeas" }
    }

    my $result = "grasshopper" + "motor oil";
    is $result, "chickpeas", "can shadow an existing operator";
}