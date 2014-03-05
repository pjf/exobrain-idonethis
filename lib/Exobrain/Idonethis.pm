package Exobrain::Idonethis;
use Moose;
use feature qw(say);

# ABSTRACT: Idonethis components for Exobrain
# VERSION

with 'Exobrain::Component';

sub component { "idonethis" };

sub services {
    return (
        sink => 'Idonethis::Sink',
    );
}

sub setup {

    # Load module and die swiftly on failure
    eval 'use WebService::Idonethis';
    die $@ if $@;

    say "Welcome to the Exobrain::Idonethis setup process.";
    say "Nothing fancy here, we just need a username/email and password.\n";

    print "Username or email: ";
    chomp( my $username = <STDIN> );

    print "Password: ";
    chomp( my $password = <STDIN> );

    # Check to see if we auth okay.

    my $idt = WebService::Idonethis->new(
        user => $username,
        pass => $password,
    );

    say "\nThanks! Writing configuration...";

    my $config =
        "[Components]\n" .
        "Idonethis=$VERSION\n\n" .

        "[Idonethis]\n" .
        "user = $username\n" .
        "pass = $password\n"
    ;

    my $filename = Exobrain::Config->write_config('Idonethis.ini', $config);

    say "\nConfig written to $filename. Have a nice day!";

    return;
}

1;

=for Pod::Coverage setup services component
