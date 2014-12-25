# StackedConfig
 [![Build Status](https://travis-ci.org/lbriais/stacked_config.svg)](https://travis-ci.org/lbriais/stacked_config)
 [![Gem Version](https://badge.fury.io/rb/stacked_config.svg)](http://badge.fury.io/rb/stacked_config)

The purpose of this gem is to provide a __simple__ way to handle the __inheritance__ of __config files__ for a ruby
script. By default, it will handle already few config layers:

* The __system layer__, which is a level common to all applications using this gem.
* The __global layer__, which is the level to declare options for all users that use the ruby script using this gem.
* The __user layer__, which is the level, where a user can set options for the ruby script using this gem.
* The __extra layer__, which provides the possibility to specify a config file from the command line.
* The __command-line layer__, which provides the ability to specify options from the command line.
* The __override layer__, which will contain all modifications done to the config at run time.

The different layers are evaluated by default in that order using the [super_stack gem][SS] (Please read for more
detail).

All the config files are following the [YAML] syntax.

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

Try this little script and then create some config files to test how it is handled (see next section to know where to
create the config files).


### Where are my config files ?

`stacked_config` will look for config files in different places depending on the layer we are talking about. Have a look
at the source to understand where exactly your config files can be, but basically it is following the Unix way of
doing things...

* Sources for the [system layer][SystemLayer]
* Sources for the [global layer][GlobalLayer]
* Sources for the [user layer][UserLayer]

As you can see in the sources, paths are expressed using kind of 'templates', which meaning should be obvious

* `##SYSTEM_CONFIG_ROOT##` is where the system config is stored. On Unix systems, it should be `/etc`.
* `##PROGRAM_NAME##` is by default the name of the script you are running (with no extension). You can if you want
  change this name at runtime. Changing it will trigger a re-search and reload of all the config files.
* `##USER_CONFIG_ROOT##` is where the user config is stored. On Unix systems, it should be your `$HOME` directory.
* `##EXTENSION##` is one of the following extensions : `conf CONF cfg CFG yml YML yaml YAML`.

The search of the config files is done according to the order defined in sources just above and then extensions
are tried according to the extensions just above in that exact order.

__The first file matching for a particular level is used !__ And there can be only one per level.

Thus according to the rules above, and assuming my script is named `my_script.rb` if the two following files exists at
user config level, only the first is taken in account:

* `~/.my_script.yml`
* `~/.config/my_script.conf`


### Script command line options

`stacked_config` uses internally the fantastic [Slop] gem to manage options coming from
the command line.

To define your options the command-line layer exposes a `slop_definition` method that enables
to directly configure slop.

For most usages you can use the higher level method `add_command_line_section` from the orchestrator.

```ruby
require 'stacked_config'

config = StackedConfig::Orchestrator.new
config.add_command_line_section do |slop|
  slop.on :u, :useless, 'Stupid option', :argument => false
  slop.on :an_int, 'Stupid option with integer argument', :argument => true, :as => Integer
end
```

The `add_command_line_section` method supports a parameter to define the name of the section.

By defaut the following command line options are available:

* auto                 Auto mode. Bypasses questions to user. Just provided for convenience. Not used anywhere in the
                       code.
* simulate             Do not perform the actual underlying actions. Just provided for convenience. Not used anywhere
                       in the code.
* verbose              Enable verbose mode. Just provided for convenience. Not used anywhere in the code.
* help                 Displays this help. Just provided for convenience. Not used anywhere in the code.
* config-file          Specify a config file for the extra layer.
* config-override      If specified override all other config (actually changes the merge policy see [below]
                       (#changing-the-way-things-are-merged)).

Flags that are said "Just provided for convenience. Not used anywhere in the code." are just there because they are
standard options and thus you can easily test in your code.

```ruby
puts "Something very important" if config[:verbose]
```



### Advanced usage

#### Re-ordering layers

The way layers are processed is done according to their priority. By default the existing layers have the following
priorities:

* The system layer has a priority of 10
* The global layer has a priority of 20
* The user layer has a priority of 30
* The extra layer has a priority of 40
* The command-line layer has a priority of 100
* The override layer has a priority of 1000

But imagine you want to say that no-one could override properties defined at the system and global layer even from the
command-line, then you just have to change the priorities of those 2 layers.

```ruby
require 'stacked_config'

config = StackedConfig::Orchestrator.new
config.system_layer.priority = 1500
config.global_layer.priority = 1600
```

By doing such the system and global layers will be evaluated after the command line layer and therefore properties set
in those files cannot be overridden even at command line level.


#### Adding extra layers

Imagine you want to add a specific layer in your config, coming from let's say a web-service or a database, you may
create your own layers for this purpose. Have a look at [super_stack gem][SS] for further info about how to create
layers.

But basically just create your new layer, gives it a priority and add it to the orchestrator.

#### Changing the way things are merged

The [super_stack gem][SS] defines some different merge policies. By default `stacked_config` will use the
SuperStack::MergePolicies::FullMergePolicy that merges hashes and arrays at all levels. But you can choose to completely
change the merge behaviour by changing the merge policy. See [super_stack gem][SS] documentation for other merge
policies.

Merge policies can be changed either at orchestrator level or at layer level by setting the merge_policy property.

This is actually exactly what happens when the `config-override` flag is passed on the command line. It triggers the
change of the merge policy of the extra layer from SuperStack::MergePolicies::FullMergePolicy to
SuperStack::MergePolicies::OverridePolicy.

## Contributing

1. [Fork it] ( https://github.com/lbriais/stacked_config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[SS]:          https://github.com/lbriais/super_stack       "Super Stack gem"
[SystemLayer]: https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/system_layer.rb "the system layer places where config files are searched"
[GlobalLayer]: https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/global_layer.rb "the global layer places where config files are searched"
[UserLayer]:   https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/user_layer.rb   "the user layer places where config files are searched"
[YAML]:        http://www.yaml.org/    "The Yaml official site"
[Slop]:        https://rubygems.org/gems/slop   "The Slop gem"
