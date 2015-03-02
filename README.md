# Stronger

Stronger is a basic run-time type-safety kit for Ruby, which introduces a couple
of tools for simple run-time type checking.

There's nothing revolutionary here.  Just a few convenient types and methods to
ease the burden of the type-conscious rubyist.

## Features

### Collections

Stronger provides some type-checking wrappers around Ruby's Hash and Array
classes, which help give you a bit of type-safety in the values you can expect
from these collections.

### Properties

Stronger comes with a module (PropertyDefinition) which gives you a way to specify
typed properties on your objects.

### Interfaces

Polymorphism via duck-typing tends to be a little painful in Ruby, as
validating object interfaces usually means littering `responds_to?` throughout
your code.  Stronger has a very simple (and very dumb) concept of an `Interface`,
which is just a list of methods objects must respond to encapsulated in an
object.  These `Interface` objects can be treated as types however, which makes
duck-typing with Collections and Properties a lot nicer.
