# StackedConfig
 [![Build Status](https://travis-ci.org/lbriais/stacked_config.svg)](https://travis-ci.org/lbriais/stacked_config)
 [![Gem Version](https://badge.fury.io/rb/stacked_config.svg)](http://badge.fury.io/rb/stacked_config)

The purpose of this gem is to provide a simple way to handle the inheritance of config files for a ruby script.
By default, it will handle already few config layers:

* The __system layer__, which is a level common to all applications using this gem.
* The __global layer__, which is the level to declare options for all users that use the ruby script using this gem.
* The __user layer__, which is the level, where a user can set options for the ruby script using this gem.
* The __extra layer__, which provides the possibility to specify a config file from the command line.
* The __command-line layer__, which provides the ability to specify options from the command line.
* The __override layer__, which will contain all modifications done to the config at run time.

The different layers are evaluated by default in that order using the [super_stack gem](SS) (Please read for more
detail).

All the config files are following the [YAML](yaml) syntax.

## Installation

Add this line to your application's Gemfile:

    gem 'stacked_config'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stacked_config

## Usage

### Basics

`stacked_config` is a very versatile configuration system for your scripts. The default behaviour may satisfy most of
 the needs out of the box.

```ruby
require 'stacked_config'

config = StackedConfig::Orchestrator.new

config[:runtime_property] = 'A runtime property'

# Displays all the internals of the config:
puts config.detailed_layers_info

# Normally you may probably only need to access some properties
if config[:help]
    puts config.command_line_help
end
```

### Where are my config files ?

`stacked_config` will look for config files in different places depending on the layer we are talking about. Have a look
at the source to understand where exactly your config files can be, but basically it is following the Unix way of
doing things...

* Sources for the [system layer](SystemLayer)
* Sources for the [global layer](GlobalLayer)
* Sources for the [user layer](UserLayer)

As you can see in the sources, paths are expressed using kind of 'templates', which meaning should be obvious

* `##SYSTEM_CONFIG_ROOT##` is where the system config is stored. On Unix systems, it should be `/etc`.
* `##PROGRAM_NAME##` is by default the name of the script you are running (with no extension). You can if you want
  change this name at runtime. Changing it will trigger a re-search and reload of all the config files.
* `##USER_CONFIG_ROOT##` is where the user config is stored. On Unix systems, it should be your `$HOME` directory.
* `##EXTENSION##` is one of the following extensions : `conf CONF cfg CFG yml YML yaml YAML`.

### Script command line options

### Advanced usage

## Contributing

1. [Fork it] ( http://github.com/lbriais/stacked_config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[SS]:          https://github.com/lbriais/super_stack       "Super Stack gem"
[SystemLayer]: https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/system_layer.rb "the system layer places where config files are searched"
[GlobalLayer]: https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/global_layer.rb "the global layer places where config files are searched"
[UserLayer]:   https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/user_layer.rb   "the user layer places where config files are searched"
[yaml]:        http://www.yaml.org/    "The Yaml official site"
