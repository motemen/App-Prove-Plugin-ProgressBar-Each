package App::Prove::Plugin::ProgressBar::Each;
use strict;
use warnings;

our $VERSION = '0.01';

sub load {
    my ($class, $p) = @_;
    $p->{app_prove}->formatter('App::Prove::Plugin::ProgressBar::Formatter');
    $p->{app_prove}->merge(1);
    return 1;
}

package App::Prove::Plugin::ProgressBar::Formatter;
use base 'TAP::Formatter::Console';
use Term::ProgressBar::Simple;

sub new {
    my ($class, $args) = @_;
    $args->{verbosity} = -2;

    my $self = $class->SUPER::new($args);

    if ($ENV{PROVE_LOG}) {
        open $self->{log_fh}, '>', $ENV{PROVE_LOG} or die $!;
    }

    return $self;
}

sub open_test {
    my ($self, $test, $parser) = @_;

    $self->_set_colors('green');

    my $name = sprintf '%-25s', "$test";
    if (length $name > 25) {
        $name = '...' . substr $name, -22;
    }
    my $progress = Term::ProgressBar::Simple->new({
        name  => $name,
        count => 1000,
    });
    $self->{progress} = $progress;

    $parser->callback(
        EOF => sub {
            my $parser = shift;
            if ($parser->failed || $parser->parse_errors) {
                $self->_set_colors('red');
            }
            my $newline = defined $self->{progress} && $self->{progress}->{tpq}->target;
            undef $self->{progress};
            print "\n" if $newline;
            $self->_set_colors('reset');
        }
    );

    $parser->callback(
        plan => sub {
            my $plan = shift;
            $self->{progress}->{tpq}->target($plan->tests_planned);
            $self->{progress}->{args}->{count} = $plan->tests_planned;

            if ($plan->directive) {
                my $tpq = $self->{progress}->{tpq};
                $tpq->target(1);
                undef $self->{progress};
                print { $tpq->fh } "\r", $tpq->name, ': ', $plan->directive;
            }
        }
    );

    $parser->callback(
        test => sub {
            my $test = shift;
            if (not $test->is_ok) {
                $self->_set_colors('red')
            }
            $self->{progress}++;
            undef;
        }
    );

    $parser->callback(
        ALL => sub {
            my $result = shift;
            my $message = $result->as_string;
            $message .= "\n" unless $message =~ /\n$/;
            print { $self->{log_fh} } $message;
        }
    ) if $self->{log_fh};

    $self->SUPER::open_test($test, $parser);
}

1;

__END__

=head1 NAME

App::Prove::Plugin::ProgressBar::Each -

=head1 SYNOPSIS

  use App::Prove::Plugin::ProgressBar::Each;

=head1 DESCRIPTION

App::Prove::Plugin::ProgressBar::Each is

=head1 AUTHOR

motemen E<lt>motemen {at} gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
