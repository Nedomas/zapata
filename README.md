# Zapata

Who has time to write tests? This is a revolutional tool to make them write themselves.


![Emiliano Zapata](https://cloud.githubusercontent.com/assets/1877286/3753719/af3bfec2-1814-11e4-8790-242c2b26a8e9.jpg)

# Working prototype

So here comes a day where we have this bullshit class to test

```ruby
class Person < Object
  def initialize(name, shop_id)
    @name = name
    @shop_ids = shop_ids
    @code = :some_code
    @prefix = 'funky'
    show_name_with_prefix(prefix)
  end

  def show_shop_ids
    Hello.p @shop_ids
  end

  def show_name_with_prefix(prefix)
    "#{prefix}_#{@name}"
  end

  def whats_my_code(code)
    code
  end
end
```

We just run ``ruby lib/zapata.rb`` and make pop the champagne.
Here's what Zapata generated us. More data to analyse means better predictions.

```ruby
require 'spec_helper'

describe PersonSpec do

  let(:person) { Person.new('UNSURE_LVAR_name', 'NEVER_SET_shop_id') }

  describe '#show_shop_ids' do
    expect(@person.show_shop_ids).to eq()
  end

  describe '#show_name_with_prefix' do
    expect(@person.show_name_with_prefix('funky')).to eq()
  end

  describe '#whats_my_code' do
    expect(@person.whats_my_code(:some_code)).to eq()
  end

end
```

## Installation

Install by looking at source code.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/zapata/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
