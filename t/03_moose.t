package Hoge;
use Mouse;

package main;
use strict;
use warnings;
use Test::More;
use Test::Requires qw(Moose::Util::TypeConstraints);
use Test::TypeConstraints qw(type_isa);

my $hoge = Hoge->new;

my $subtype = subtype 'HogeClass' => as 'Object' => where { $_->isa("Hoge") } ;
isa_ok($subtype, "Moose::Meta::TypeConstraint");
type_isa($hoge, $subtype, "Moose TypeConstraint object ok");

done_testing();
