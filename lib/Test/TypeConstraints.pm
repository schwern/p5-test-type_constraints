package Test::TypeConstraints;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.01';
use Exporter 'import';
use Test::More;
use Test::Builder;
use Mouse::Util::TypeConstraints ();
use Scalar::Util ();
use Data::Dumper;

our @EXPORT = qw/ type_isa type_does /;

sub type_isa {
    my ($got, $type, $test_name) = @_;

    my $tc;
    # duck typing for (Mouse|Moose)::Meta::TypeConstraint
    if ( Scalar::Util::blessed($type) && $type->can("check") ) {
        $tc = $type;
    } else {
        $tc = Mouse::Util::TypeConstraints::find_or_create_isa_type_constraint($type);
    }
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my $ret = ok($tc->check($got), $test_name || ( $tc->name . " types ok" ) )
        or diag(sprintf('type: "%s" expected. but got %s', $tc->name, Dumper($got)));

    return $ret;
}

sub type_does {
    my ($got, $role, $test_name) = @_;

    my $tc;
    # duck typing for (Mouse|Moose)::Meta::TypeConstraint
    if ( Scalar::Util::blessed($role) && $role->can("check") ) {
        $tc = $role;
    } else {
        $tc = Mouse::Util::TypeConstraints::find_or_create_does_type_constraint($role);
    }
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my $ret = ok($tc->check($got), $test_name || ( $tc->name . " types ok" ) )
        or diag(sprintf('role: "%s" expected. but got %s', $tc->name, Dumper($got)));

    return $ret;
}

1;
__END__

=head1 NAME

Test::TypeConstraints - testing whether some value is valid as (Moose|Mouse)::Meta::TypeConstraint

=head1 SYNOPSIS

  use Test::TypeConstraints qw(type_isa);

  type_isa($got, "ArrayRef[Int]", "type should be ArrayRef[Int]");

=head1 DESCRIPTION

Test::TypeConstraints is for testing whether some value is valid as (Moose|Mouse)::Meta::TypeConstraint.

=head1 METHOD

=head2 type_isa($got, $typename_or_type, $test_name)

    $got is value for checking.
    $typename_or_type is a Classname or Mouse::Meta::TypeConstraint name or "Mouse::Meta::TypeConstraint" object or "Moose::Meta::TypeConstraint::Class" object.

=head2 type_does($got, $rolename_or_role, $test_name)

    $got is value for checking.
    $typename_or_type is a Classname or Mouse::Meta::TypeConstraint name or "Mouse::Meta::TypeConstraint" object or "Moose::Meta::TypeConstraint::Role" object.

=head1 AUTHOR

Keiji Yoshimi E<lt>walf443 at gmail dot comE<gt>

=head1 THANKS TO

gfx

tokuhirom

=head1 SEE ALSO

+<Mouse::Util::TypeConstraints>, +<Moose::Util::TypeConstraints>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
