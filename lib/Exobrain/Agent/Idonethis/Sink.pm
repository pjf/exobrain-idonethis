package Exobrain::Agent::Idonethis::Sink;
use Method::Signatures;
use Moose;

with 'Exobrain::Agent::Idonethis';
with 'Exobrain::Agent::Run';

# ABSTRACT: Send personal log events to iDoneThis
# VERSION

method run() {
    $self->exobrain->watch_loop(
        class => 'Intent::PersonalLog',
        then  => sub {
            my $event = shift;

            my $text = $event->summary;

            $self->idone->set_done(
                text => $text,
                date => $self->to_ymd( $event->timestamp ),
            );

            # Send low-priority notify that we've logged this.
            $self->exobrain->notify( "Logged (iDoneThis): $text", priority => -1 );
        }
    );
}

1;
