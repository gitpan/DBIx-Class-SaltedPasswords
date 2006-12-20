package DBIx::Class::SaltedPasswords;

use base qw(DBIx::Class);
use strict;
use warnings;

require Exporter;


our $VERSION = '0.01';






__PACKAGE__->mk_classdata( 'salted_enabled' => 1 );
__PACKAGE__->mk_classdata( 'salted_columns' => [] );
__PACKAGE__->mk_classdata( 'salted_salt' => "perlrulez" );


sub saltedpasswords {
	my $self = shift;
	my %args = @_;
	$args{columns} = [ $args{columns} ]
	  unless ( ref( $args{columns} ) eq "ARRAY" );
	$self->salted_columns($args{columns});
	$self->salted_enabled($args{enabled}) if exists $args{enabled};
	$self->salted_salt($args{salt}) if exists $args{salt};
}

sub insert {
	my $self = shift;
	if ( $self->salted_enabled ) {
		for my $column ( @{ $self->salted_columns } ) {
			#die $self->get_column($column) . $self->salted_salt;
			$self->set_column( $column,
				$self->get_column($column) . $self->salted_salt )
			  if defined $self->get_column($column);
		}
	}
	return $self->next::method(@_);
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

DBIx::Class::SaltedPasswords - Salts password columns

=head1 SYNOPSIS

  __PACKAGE__->load_components(qw/SaltedPasswords ... Core /);
  __PACKAGE__->saltedpasswords( 
     columns => [qw/ password /], 
     salt    => "perlrulez",
     enabled => 1
  );

=head1 DESCRIPTION

Adds a salt to the value for selected columns.

=head1 EXTENDED METHODS

The following L<DBIx::Class::Row> methods are extended by this module:-

=over 4

=item insert

=head1 TODO

extend methods: update, search, find


=head1 SEE ALSO

L<DBIx::Class>

=head1 AUTHOR

Moritz Onken (perler)

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by root

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
