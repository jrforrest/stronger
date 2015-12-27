# Stronger

Stronger is a basic run-time type-safety kit for Ruby, which introduces a couple
of tools for simple run-time type checking.

There's nothing revolutionary here.  Just a few convenient types and methods to
ease the burden of the type-conscious rubyist.

## Installation

`gem install stronger` and `require 'stronger'` in your code.

## Features

### Collections

Stronger provides some type-checking wrappers around Ruby's Hash and Array
classes, which help give you a bit of type-safety in the values you can expect
from these collections.

##### Array

Typed arrays check anything appended.

```ruby
  arr = Stronger::TypedArray.new(Integer)
  arr.push 5

  arr.push 4 # raises TypeError
```

They also refuse to concatenate with other TypedArrays not of the same type.

##### Hash

Typed hashes check values added to ensure type.

```ruby
  hash = Stronger::TypedHash.new(String)
  hash[:first] = 'Groovy'
  hash[2] = :woah_there # raises TypeError
```

### Properties

Some class methods are provided in the `PropertyDefinition` module which allows
you to define properties on classes.  Properties are required by default,
can be set via the constructor, the private `set_properties` method, or setters.

```ruby
  class Person
    property :name, type: String
    property :phone_number, type: String, required: false
  end

  addr = AddressBookEntry.new(name: "Boris")
  addr.name #=> 'Boris'
  addr.name = 3 # Raises Stronger::InvalidProperty
```


### Interfaces

Stronger has a very simple (and very dumb) concept of an `Interface`,
which is just a list of methods objects must respond to encapsulated in an
object.  These `Interface` objects can be treated as types however, which makes
duck-typing with Collections and Properties a lot nicer.

```ruby
  AnimalInterface = Stronger::Interface.new(:move, :make_noise)

  class Dog
    def move
    end

    def make_noise
    end
  end
```

The `AnimalInterface` defined above can be used in place of classes for types
in Stronger's properties and typed collections.

### Type checking methods

The `Stronger::TypeChecking` refinement provides a `is_strong?` method on
`Object` which allows you to check types yourself.  It behaves like `is_a?`
but includes support for interface checking.

```ruby
  use Stronger::TypeChecking

  BoatInterface = Stronger::Interface.new(:float)

  Object.new.is_strong?(Object) # => true
  Object.new.is_strong?(Boat) # => false
```

## Contributing

Fork and open a PR.  Please include tests and ensure `rake test` runs.

## License

See LICENSE
