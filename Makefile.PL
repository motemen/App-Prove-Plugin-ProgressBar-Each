use inc::Module::Install;
name 'App-Prove-Plugin-ProgressBar-Each';
all_from 'lib/App/Prove/Plugin/ProgressBar/Each.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
