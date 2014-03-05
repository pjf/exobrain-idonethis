package Exobrain::Agent::Idonethis;
use Moose::Role;
use Method::Signatures;
use WebService::Idonethis 0.22;
use POSIX qw(strftime);

with 'Exobrain::Agent';

# ABSTRACT: Roles for to iDonethis agents
# VERSION

=head1 SYNOPSIS

    use Moose;
    with 'Exobrain::Agent::Idonethis'

=head1 DESCRIPTION

This role provides useful methods and attributes for agents wishing
to integrate with the iDoneThis web service.

=cut

sub component_name { "Idonethis" }

=method idone

    $self->idone->set_done( text => '... ');

This returns a L<WebService::Idonethis> object that's already been
constructed and authenticated.

=cut

has idone => ( is => 'ro', lazy => 1, builder => '_build_idonethis' );

method _build_idonethis() {
    my $config = $self->config;

    my $user = $config->{user} or die "Can't find Idonethis/user";
    my $pass = $config->{pass} or die "Can't find Idonethis/pass";

    return WebService::Idonethis->new(
        user => $user,
        pass => $pass,
    );
}

=method to_ymd

    my $ymd = $self->to_ymd( time );

Converts a time in epoch seconds to C<YYYY-MM-DD> format in
the local timezone.

=cut

method to_ymd($epoch_seconds) {
    return strftime("%Y-%m-%d", localtime( $epoch_seconds )),
}

1;

=for Pod::Coverage component_name
