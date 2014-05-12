# Syllabize

[![Code Climate](https://codeclimate.com/github/thenickcox/syllabize.png)](https://codeclimate.com/github/thenickcox/syllabize)

Syllabize is a simple syllable counter written in Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'syllabize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install syllabize

## Usage

First, require `syllabize`. Then, you can call the `count_syllables` method on a string.

```bash
require 'syllabize'
# => true
'Ruby'.count_syllables
# => 2
```

As of version 0.6.0, syllabize now supports numbers and multiword strings.

```bash
require 'syllabize'
# => true
'500'.count_syllables
# => 3
'this gem is cool'.count_syllables
# => 4
```



## Contributing

### File an issue
The English language is full of exceptions to rules. One of the best ways to contribute is to [file an issue](https://github.com/thenickcox/syllabize/issues) with any exceptions you find.

### Hack on the gem
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write tests and run them (`rake` or `rspec`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
