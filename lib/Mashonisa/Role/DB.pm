package Mashonisa::Role::DB;

use Mouse::Role;

use Mashonisa::DB;
use experimental qw/ signatures /;

has db => (
    is => 'ro',
    isa => 'Mashonisa::DB',
    lazy => 1,
    default => sub { return Mashonisa::DB->new }
);

1;
