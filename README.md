This is Perl module App::Prove::Plugin::ProgressBar::Each.

DESCRIPTION
===========

Is an App::Prove plugin that shows progress bar for each test script.

Run

	perl t/live.pl

to see how it works.

HOW TO USE
==========

prove with -P:

	prove -PProgressBar::Each

Set $ENV{PROVE_LOG} to save testing log.
