This is Perl module App::Prove::Plugin::ProgressBar::Each.

DESCRIPTION
===========

App::Prove plugin that shows progress bar for each test script.
Greatly inspired by [App::Prove::Plugin::ProgressBar](http://github.com/Ovid/App-Prove-Plugin-ProgressBar).

Run

	perl t/live.pl

to see how it works.

HOW TO USE
==========

prove with -P:

	prove -PProgressBar::Each

Set `$ENV{PROVE_LOG}` to save testing log.
