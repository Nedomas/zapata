# Zapata

Who has time to write tests? This is a revolutionary tool to make them write
themselves.

[![Gem Version](http://img.shields.io/gem/v/zapata.svg?style=flat)][rubygems]
[![Build Status](http://img.shields.io/travis/Nedomas/zapata.svg?style=flat)][travis]
[![Dependency Status](http://img.shields.io/gemnasium/Nedomas/zapata.svg?style=flat)][gemnasium]
[![Coverage Status](http://img.shields.io/coveralls/Nedomas/zapata/master.svg?style=flat)][coveralls]
[![Code Climate](http://img.shields.io/codeclimate/github/Nedomas/zapata.svg?style=flat)][codeclimate]

![Emiliano Zapata](https://cloud.githubusercontent.com/assets/1877286/3753719/af3bfec2-1814-11e4-8790-242c2b26a8e9.jpg)

# What is your problem?

There comes a day where you have this bullshit class ``RobotToTest``. We need
tests. :shipit:

```ruby
class RobotToTest
  def initialize(human_name, cv)
    @name = robot_name(human_name)
  end

  def robot_name(human_name)
    "#{self.class.prefix}_#{human_name}"
  end

  def cv
    { planets: planets }
  end

  def nested_fun_objects(fun_objects)
    'It was fun'
  end

  def self.prefix
    'Robot'
  end

  private

  def planets
    ['Mars', Human.home]
  end

  def fun_objects
    [%i(array in array), { hash: nested_hash }]
  end

  def nested_hash
    { in_hash: { in: array } }
  end

  def array
    %w(array)
  end
end

# just another class to analyze
class Human
  def initialize
    human_name = 'Emiliano'
  end

  def self.home
    'Earth'
  end
end
```

## Solving it

You run ``zapata generate app/models/robot_to_test.rb`` and pop the champagne.
Zapata generated ``spec/models/robot_to_test_spec.rb`` for you.

```ruby
describe RobotToTest do
  let(:robot_to_test) do
    RobotToTest.new('Emiliano', { planets: ['Mars', Human.home] })
  end

  it '#robot_name' do
    expect(robot_to_test.robot_name('Emiliano')).to eq('Robot_Emiliano')
  end

  it '#cv' do
    expect(robot_to_test.cv).to eq({ planets: ['Mars', 'Earth'] })
  end

  it '#nested_fun_objects' do
    expect(robot_to_test.nested_fun_objects([
      [:array, :in, :array],
      {
        hash: {
          in_hash: {
            in: ['array']
          }
        }
      }
    ])).to eq('It was fun')
  end

  it '#prefix' do
    expect(RobotToTest.prefix).to eq('Robot')
  end
end
```

## What does it do?

It tries to write a passing RSpec spec off the bat. It does fancy analysis
to predict the values it could feed to the API of a class.

__To be more specific:__
- Analyzes all vars and methods definitions in ``app/models``
- Checks what arguments does a testable method in ``app/models/robot_to_test.rb`` need
- Searches for such variable or method name in methods in analyzed
- Selects the most probable value by how many times it was repeated in code
- Runs the RSpec and fills in the expected values of the test with those returned by RSpec

For more things it can currently do check
https://github.com/Nedomas/zapata/tree/master/spec

## Workflow with Zapata

Say you are writing some new feature on your existing project.
Before writing that, you probably want to test out the current functionality.
But who has time for that?

You let *Zapata* create that quick spec for you.
Think of it as a *current functionality lock*.
Write more code and when you're happy with the result - lock it up again.

## Requirements

- Ruby 2.0+
- Rails 3.0+

Ruby 1.9.3 and older version support is in next release and can be checked out [here](https://github.com/Nedomas/zapata/issues/2).

## Installation

It should be as easy as
```sh
gem install zapata
```

or

```ruby
gem 'zapata', groups: %w(development test)
```

## Usage

To use run
```sh
zapata generate app/models/model_name.rb
```

To ignore other files and analyze a single model you want to generate a spec for:
```sh
zapata generate app/models/model_name.rb --single
```

## Collaboration :heart:

It is encouraged by somehow managing to bring a cake to your house. I promise,
I will really try.

This is a great project to understand language architecture in general. A
project to let your free and expressionistic side shine through by leaving meta
hacks and rainbows everywhere.

Thank you to everyone who do. I strongly believe that this can make the
developer job less robotic and more creative.

1. [Fork it](https://github.com/Nedomas/zapata/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

To install, run:
```sh
cd zapata
script/bootstrap
```

For specs:

```sh
script/test

# or

bundle exec rspec --pattern "spec/*_spec.rb"
```

## Awareness

I am well aware that this is featured in [Ruby Weekly 223](http://rubyweekly.com/issues/223).
On that note I'd like to thank everybody who helped it shine through.

Special thanks to my comrade [@jpalumickas](https://github.com/jpalumickas), with whom we share a vision of a better world.
Also - thank you [@edgibbs](https://github.com/edgibbs), for being the early contributor.

## Copyright
Copyright (c) 2014 Domas.
See [LICENSE](LICENSE) for details.

[rubygems]: https://rubygems.org/gems/zapata
[travis]: http://travis-ci.org/Nedomas/zapata
[gemnasium]: https://gemnasium.com/Nedomas/zapata
[coveralls]: https://coveralls.io/r/Nedomas/zapata
[codeclimate]: https://codeclimate.com/github/Nedomas/zapata
