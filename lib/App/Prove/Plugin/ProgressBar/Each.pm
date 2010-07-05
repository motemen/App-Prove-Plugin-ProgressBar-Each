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
    return $class->SUPER::new($args);
}

sub open_test {
    my ($self, $test, $parser) = @_;

    print "\n" if exists $self->{progress};
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
            if ($parser->actual_failed || $parser->parse_errors) {
                $self->_set_colors('red');
            }
            undef $self->{progress};
            $self->_set_colors('reset');
        }
    );

    $parser->callback(
        plan => sub {
            my $plan = shift;
            $self->{progress}->{tpq}->target($plan->tests_planned);
            $self->{progress}->{args}->{count} = $plan->tests_planned;
        }
    );

    $parser->callback(
        test => sub {
            my $test = shift;
            if (not $test->is_ok) {
                print "\r", (' ' x $self->{progress}->{tpq}->term_width);
                $self->_set_colors('red')
            }
            $self->{progress}++;
            undef;
        }
    );

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
