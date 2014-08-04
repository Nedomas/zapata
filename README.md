# Zapata

Who has time to write tests? This is a revolutional tool to make them write themselves.


![Emiliano Zapata](https://cloud.githubusercontent.com/assets/1877286/3753719/af3bfec2-1814-11e4-8790-242c2b26a8e9.jpg)

# Working prototype

There comes a day where you have this bullshit class ``RobotToTest`` to test.

```ruby
class RobotToTest < Object
  def initialize(name, shop_id, sex, has_children)
    has_children = true
    random_false_value = false
    @name = name
    @shop_ids = [1, 2, 3]
    @code = :some_code
    code = :some_other_code
    @prefix = 'funky'
    show_name_with_prefix(@prefix)

    run_helping_method = some_helping_method
    test_method_return_as_arg(run_helping_method)
  end

  def show_shop_ids
    shop_id = 11
    code = :some_other_code
    p @shop_ids
  end

  def some_helping_method
    'hello'
  end

  def test_method_return_as_arg(run_helping_method)
    p run_helping_method
  end

  def testing_true_and_false(has_children, random_false_value)
    has_children
  end

  def testing_empty_method
  end

  def testing_hash(options_hash)
    options_hash = { one: :thing, led: :to_another }
  end

  def show_name_with_prefix(prefix)
    "#{prefix}_#{@name}"
  end

  def whats_my_code(code)
    code
  end
end
```

You just run ``zapata generate app/models/robot_to_test.rb`` and pop the champagne.
Zapata generated ``spec/models/robot_to_test_spec.rb`` and prefills it with its own data.
The more data it has, the more accurate the generated spec is. It automatically
does the analysis of classes in ``app/{models,controllers}`` and gathers data.

It __live evaluates__ RSpec file it generated and prefills expected values.

```ruby
require 'rails_helper'

describe RobotToTest do

  let(:robot_to_test) { RobotToTest.new('John3000', 11, Zapata::Missing.new(:never_set, :sex), true) }

  it '#show_shop_ids' do
    expect(robot_to_test.show_shop_ids).to eq([1, 2, 3])
  end

  it '#some_helping_method' do
    expect(robot_to_test.some_helping_method).to eq('hello')
  end

  it '#test_method_return_as_arg' do
    expect(robot_to_test.test_method_return_as_arg('hello')).to eq('hello')
  end

  it '#testing_true_and_false' do
    expect(robot_to_test.testing_true_and_false(true, false)).to eq(true)
  end

  it '#testing_empty_method' do
    expect(robot_to_test.testing_empty_method).to eq()
  end

  it '#testing_hash' do
    expect(robot_to_test.testing_hash({:one=>:thing, :led=>:to_another})).to eq({:one=>:thing, :led=>:to_another})
  end

  it '#show_name_with_prefix' do
    expect(robot_to_test.show_name_with_prefix('funky')).to eq('funky_John3000')
  end

  it '#whats_my_code' do
    expect(robot_to_test.whats_my_code(:some_other_code)).to eq(:some_other_code)
  end

end
```

## Installation

It in unreleased and unstable at the moment, but you can install it by
```
gem 'redcarpet', :git => 'git://github.com/tanoku/redcarpet.git'
```

I doubt it will work easily out of the box so check ``lib/zapata.rb``

## Contributing

1. Fork it ( https://github.com/[my-github-username]/zapata/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
