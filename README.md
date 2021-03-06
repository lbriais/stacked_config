# StackedConfig
 [![Build Status](https://travis-ci.org/lbriais/stacked_config.svg)](https://travis-ci.org/lbriais/stacked_config)
 [![Gem Version](https://badge.fury.io/rb/stacked_config.svg)](http://badge.fury.io/rb/stacked_config)

If you need to manage config files accross the system, some of them belonging to the administrator some to the user
running the application, some coming from the command line and more, __[This Gem]
(http://rubygems.org/gems/stacked_config) is made for you__ !

The purpose of this gem is to provide a __simple__ way to handle the __inheritance__ of __config files__ for a ruby
script. By default, it will handle already few config layers:

* The __system layer__, which is a layer common to all applications using this gem.
* The __executable gem layer__, which is the layer that will enable a script provided by a gem to embed its own default
  config. __You may consider this level as the layer where you will set the default values for the properties of your
  executable__. This layer will get the config from the Gem that hosts the current __executable__ running.
* The __gem layer__, which is the layer that will enable a gem to embed its own default config. Nevertheless as it is
  not really possible to guess automatically the name of the gem, it has to be created manually.
* The __global layer__, which is the layer to declare options for all users that use the ruby script using this gem.
* The __user layer__, which is the layer, where a user can set options for the ruby script using this gem.
* The __extra layer__, which provides the possibility to specify another config file from the config itself.
* The __enviroment variables layer__, which provides the possibility to include in the config variables coming from
  the shell variables. See [below](#environment-variables) for more info. This level is optional and not created by
  default.
* The __command-line layer__, which provides the ability to specify options from the command line.
* The __override layer__, which will contain all modifications done to the config at run time.

The different layers are evaluated by default in that order using the [super_stack gem][SS] (Please read for more
detail). The `StackedConfig::Orchestrator` will expose a merged view of all its layers without modifying them.

All the config files are following the [YAML] syntax.

__If you're looking for a complete solution for your command line scripts, including some logging features, then you
are probably looking for the [easy_app_helper Gem][EAH], which is itself internally relying on [stacked_config][SC].__

Version 2.x introduces  non compatibilities with previous versions. Check [below]
(#between-version-1x-and-2x) for more info.

Version 1.x introduces some minor non compatibilities with previous versions. Check [below]
(#between-version-0x-and-1x) for more info.

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

Try this little script and then create some config files to test how it is handled (see [next section]
(#where-are-my-config-files-) to know where to create the config files).

You are supposed to access the merged config through the `[]` method of the orchestrator (`config[]` in the previous
example). Still you can directly modify any of the layers automatically created, you are not supposed to, and if you
modify or add any new property (a so called "runtime property"), it will actually set the property in the `override`
layer.

That's why you can always come back to the initial state by calling `reset` on the orchestrator. This actually just
clears the override layer.

Every layer is accessible through the following orchestrator properties:

* `system_layer`
* `executable_gem_layer`
* `global_layer`
* `user_layer`
* `provided_config_file_layer`
* `env_layer`
* `command_line_layer`
* `write_layer`

The 'gem_layer' has no direct accessor as there could be more than one.


### Where are my config files ?

`stacked_config` will look for config files in different places depending on the layer we are talking about. Have a look
at the source to understand where exactly your config files can be, but basically it is following the Unix way of
doing things...

All file based layers are inheriting from `StackedConfig::Layers::GenericLayer`

* Sources for the [system layer][SystemLayer]
* Sources for the [executable gem layer][ExecutableGemLayer]
* Sources for the [gem layer][GemLayer]
* Sources for the [global layer][GlobalLayer]
* Sources for the [user layer][UserLayer]

The search of the config files for a layer is done according to the order defined in `possible_sources` just above
and then extensions are tried according to the extensions just above in that exact order.

__The first file matching for a particular level is used ! And there can be only one per level.__

Thus according to the rules above, and assuming my script is named `my_script.rb` if the two following files exists at
user config level, only the first is taken in account:

* `~/.my_script.yml`
* `~/.config/my_script.conf`

you can get information about all files that are checked by the layers inheriting from
`StackedConfig::Layers::GenericLayer` by using the orchestrator convenience method `detailed_config_files_info` that
returns a hash which keys are the file names and values are hashes of information stating if the file is valid or used.


### Environment variables

`stacked_config` can read information from your ENV variables thanks to the dedicated `env_layer`. __This layer is not
 created by default__, it is up to you to add it to your application, due to the fact that you will use it mostly
 with an optional filter and that you may want to add it with different priorities regarding your use case:

```ruby
require 'stacked_config'

config = StackedConfig::Orchestrator.new
env_layer =  StackedConfig::Layers::EnvLayer.new(optional_filter)
config.add_layer(envLayer)
env_layer.name = 'Environment variables level'
env_layer.priority = 60
```

Or the exactly same using the convenience method of the orchestrator:

```ruby
require 'stacked_config'

config = StackedConfig::Orchestrator.new
config.include_env_layer(optional_filter, optional_priority)
```

Which does not prevent you changing afterwards its priority using the config's `env_layer` accessor.

The constructor parameter `optional_filter` parameter aims at filtering the ENV variables:

* if nil, all the ENV[] content will be added to the `env_layer`
* it can be a single string if you want only one variable. ex: `StackedConfig::Layers::EnvLayer.new 'VAR_NAME_1'`
* it can be an array of accepted names of variables. ex:
  `StackedConfig::Layers::EnvLayer.new ['VAR_NAME_1', 'VAR_NAME_2']`
* it can be a regexp that variables names have to match. ex: `StackedConfig::Layers::EnvLayer.new /somePattern/`

Once created you could although change the filter anytime:

```ruby
require 'stacked_config'

config = StackedConfig::Orchestrator.new
config.include_env_layer

config.env_layer.filter = /my_regexp/
```
It will automatically `reload` the `env_layer`.


### Script command line options

`stacked_config` uses internally the fantastic [Slop] gem to manage options coming from the command line within the
command line layer. This layer will be simply part of the complete config that the orchestrator exposes.

`stacked_config` is using the v3 branch of [Slop] and has not yet been adapted to the newest v4 branch.

#### Command line help

You can easily display a help using the orchestrator `command_line_help` method.

To even have a better command line help displayed you can provide optional information:

* The __application name__ through the `app_name` orchestrator property.
* The __application version__ through the `app_version` orchestrator property.
* The __application description__ through the `app_description` orchestrator property.

You could as well do this with the `describes_application` method (see [complete example]
(#a-complete-example-of-a-program-using-this-gem) at the end of this page).

```ruby
require 'stacked_config'

config = StackedConfig::Orchestrator.new

config.app_name = 'My super Application'
config.app_version = '1.0.0'
config.app_description = <<EOD
You can have a multiline description of your application.
This may help a lot having a consistent command-line help.
EOD
puts config.command_line_help
```

This would issue:

```
Usage: myscript [options]
My super Application Version: 1.0.0

You can have a multiline description of your application.
This may help a lot having a consistent command-line help.

-- Generic options -------------------------------------------------------------
        --auto                 Auto mode. Bypasses questions to user.
        --simulate             Do not perform the actual underlying actions.
    -v, --verbose              Enable verbose mode.
    -h, --help                 Displays this help.
-- Configuration options -------------------------------------------------------
        --config-file          Specify a config file.
        --config-override      If specified override all other config.
```

Which are the default options available.


#### Default command line options

By default the following command line options are available:

* __auto__             Auto mode. Bypasses questions to user. Just provided for convenience. Not used anywhere in the
                       code.
* __simulate__         Do not perform the actual underlying actions. Just provided for convenience. Not used anywhere
                       in the code.
* __verbose__          Enable verbose mode. Just provided for convenience. Not used anywhere in the code.
* __help__             Displays this help. Just provided for convenience. Not used anywhere in the code.
* __config-file__      Specify a config file for the extra layer.
* __config-override__  If specified, means that the config file specified will override all other config (actually
                       changes the merge policy [see below] (#changing-the-way-things-are-merged)) of the extra layer.

Flags that are said "Just provided for convenience. Not used anywhere in the code." are just there because they are
standard options and thus you can easily test in your code.

```ruby
puts "Something very important" if config[:verbose]
```

`stacked_config` provides a convenient method to display the command line help every user expects from a decent script:

```ruby
require 'stacked_config'

config = StackedConfig::Orchestrator.new

if config[:help]
    # command_line_help will provide a formatted help to display on the command line
    puts config.command_line_help
    exit 0
end

# ... do something else
```

#### Adding new command line options

To define your options the command-line layer exposes a `slop_definition` method that enables to directly configure
slop.

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
Check [Slop] documentation for further information.

__Of course adding new command line options will adapt the display of the `command_line_help` method of the
orchestrator__.


## Advanced usage

`stacked_config` is internally relying on the [super_stack Gem][SS] for the management of the layers, their priorities
and the way they are merged in order to provide the "merged config". Check its documentation for further info.

### Re-ordering layers

The way layers are processed is done according to their priority. By default the existing layers have the following
priorities:

* The system layer has a priority of __10__
* The executable gem layer has a priority of __20__
* The gem layer has a priority of __30__ (if exists)
* The global layer has a priority of __40__
* The user layer has a priority of __50__
* The extra layer has a priority of __60__
* The command-line layer has a priority of __100__
* The override layer has a priority of __1000__

But imagine you want to say that no-one could override properties defined at the system and global layer even from the
command-line, then you just have to change the priorities of those 2 layers.

```ruby
require 'stacked_config'

config = StackedConfig::Orchestrator.new
config.system_layer.priority = 1500
config.global_layer.priority = 1600
```

By doing such the system and global layers will be evaluated after the command line layer and therefore properties set
in those files cannot be overridden even at command line level thanks to [super_stack][SS] mechanisms.


### Adding extra layers

Imagine you want to add a specific layer in your config, coming from let's say a web-service or a database, you may
create your own layers for this purpose. Have a look at [super_stack Gem][SS] for further info about how to create
layers.

But basically just create your new layer, gives it a priority and add it to the orchestrator.

### Changing the way things are merged

The [super_stack gem][SS] defines various merge policies. By default `stacked_config` will use the
`SuperStack::MergePolicies::FullMergePolicy` that merges hashes and arrays at all levels. But you can choose to
completely change the merge behaviour by changing the merge policy. See [super_stack gem][SS] documentation for other
available merge policies.

Merge policies can be changed either at orchestrator level (globally) or at layer level (for the layer only) by setting
the `merge_policy` property.

This is actually exactly what happens when the `config-override` flag is passed on the command line. It triggers the
change of the merge policy of the extra layer from `SuperStack::MergePolicies::FullMergePolicy` to
`SuperStack::MergePolicies::OverridePolicy`.

## A complete example of a program using this Gem

Save the following file somewhere as `example.rb`.

You can use this as a template for your own scripts:

```ruby
#!/usr/bin/env ruby

require 'stacked_config'

class MyApp

  VERSION = '0.0.1'
  NAME = 'My brand new Application'
  DESCRIPTION = 'Best app ever'

  attr_reader :config

  def initialize
    @config = StackedConfig::Orchestrator.new
    config.describes_application app_name: NAME, app_version: VERSION, app_description: DESCRIPTION
    add_script_options
  end


  def add_script_options
    config.add_command_line_section('Options for the script') do |slop|
      slop.on :u, :useless, 'Stupid option', :argument => false
      slop.on :an_int, 'Stupid option with integer argument', :argument => true, :as => Integer
    end
  end

  def run
    if config[:help]
      puts config.command_line_help
      exit 0
    end
    do_some_processing
  end

  def do_some_processing
    # Here you would really start your process
    config[:something] = 'Added something...'

    if config[:verbose]
      puts ' ## Here is a display of the config sources and contents'
      puts config.detailed_layers_info
      puts ' ## This the resulting merged config'
      puts config[].to_yaml
    end

    puts ' ## Bye...'
  end

end

MyApp.new.run
```

If you run:

    $ ./example.rb

You would get:

```
 ## Bye...
```

If you run:

    $ ./example.rb --help

You would get:

```
Usage: example [options]
My brand new Application Version: 0.0.1

Best app ever
-- Generic options -------------------------------------------------------------
        --auto                 Auto mode. Bypasses questions to user.
        --simulate             Do not perform the actual underlying actions.
    -v, --verbose              Enable verbose mode.
    -h, --help                 Displays this help.
-- Configuration options -------------------------------------------------------
        --config-file          Specify a config file.
        --config-override      If specified override all other config.
-- Options for the script ------------------------------------------------------
    -u, --useless              Stupid option
        --an_int               Stupid option with integer argument
```

If you run:

    $ ./example.rb --verbose

You would get:
```
 ## Here is a display of the config sources and contents
--------------------------------------------------------------------------------
System-wide configuration level
There is no file attached to this level.
There is no data in this layer
--------------------------------------------------------------------------------
Gem configuration level
There is no file attached to this level.
There is no data in this layer
--------------------------------------------------------------------------------
Global configuration level
There is no file attached to this level.
There is no data in this layer
--------------------------------------------------------------------------------
User configuration level
There is no file attached to this level.
There is no data in this layer
--------------------------------------------------------------------------------
Specific config file configuration level
There is no file attached to this level.
There is no data in this layer
--------------------------------------------------------------------------------
Command line configuration level
There is no file attached to this level.
This layer contains the following data:
--- !ruby/hash:StackedConfig::Layers::CommandLineLayer
:verbose: true

--------------------------------------------------------------------------------
Overridden configuration level
There is no file attached to this level.
This layer contains the following data:
--- !ruby/hash:SuperStack::Layer
:something: Added something...

--------------------------------------------------------------------------------
 ## This the resulting merged config
---
:verbose: true
:something: Added something...
 ## Bye...
```


## Non backward compatible changes

### Between version 1.x and 2.x

Versions 1.x of this gem were relying on the [super_stack][SS] 0.x, whereas versions 2.x are actually
relying on the [super_stack][SS] 1.x. The reason why this gem bumps to 2.x is because of non-backward
compatible features it introduces.

Basically it is about clarifying some inconsistencies on how to access the merged tree. Previously for
the first level (roots) you could access a value using indifferently a symbol or a string as a key,
ie `manager[:an_entry]` was giving the same result as `manager['an_entry']`.

This was clearly wrong and not consistent everywhere.
__Starting with version `2.0.0` this is no more the case__. Nevertheless a compatibility mode is provided for 
applications relying on the legacy mechanism, you just need to:

```ruby
require 'stacked_config'
SuperStack.compatibility_mode = true
```

As from now any layer or manager created will have the old behaviour, but be careful, __only the newly 
created object will reflect this__.

You can switch back to standard behaviour by setting the `compatibility_mode` to false, but again only 
the newly created object will reflect this. It is advised to use one mode or the other but to avoid to 
mix...

Of course, if you don't want to use this compatibility mode, this may have an impact on you. As if in 
your code you where using this feature, you either need to change your code or your config files. (to
access a yaml property as symbol you need to declare it with a leading colon). 

For example, the following config file:

```yaml
my_property: a value
an_array:
  - value 1
  - value 2
```
Could be rewritten as 

```yaml
:my_property: a value
:an_array:
  - value 1
  - value 2
```
and then if you were accessing my_property in your code using `config[:my_property]`, you won't need
to change your code without even activating the compatibility mode.

Actually depending on your case, you may want to:

* Adapt your code to the new version without compatibility mode
* Adapt your config files to the new version without compatibility mode
* Use the new version in compatibility mode
* Keep the old version

### Between version 0.x and 1.x

The Gem layer has not really the same meaning as in version 0.x. In the v1.x it corresponds to the
executable_gem_layer.

The Gem layer still exists but is now not created automatically. You should use the `include_gem_layer_for`
orchestrator method to create one and you have to provide a Gem name and optionally a layer priority.


## Contributing

1. [Fork it] ( https://github.com/lbriais/stacked_config/fork ), clone your fork.
2. Create your feature branch (`git checkout -b my-new-feature`) and develop your super extra feature.
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a Pull Request.

[SS]:                    https://github.com/lbriais/super_stack       "Super Stack gem"
[SC]:                    https://github.com/lbriais/stacked_config    "The stacked_config Gem"
[SystemLayer]:           https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/system_layer.rb "the system layer places where config files are searched"
[ExecutableGemLayer]:    https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/executable_gem_layer.rb "the executable gem layer places where config files are searched"
[GemLayer]:              https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/gem_layer.rb "the gem layer places where config files are searched"
[GlobalLayer]:           https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/global_layer.rb "the global layer places where config files are searched"
[UserLayer]:             https://github.com/lbriais/stacked_config/blob/master/lib/stacked_config/layers/user_layer.rb   "the user layer places where config files are searched"
[YAML]:                  http://www.yaml.org/                         "The Yaml official site"
[Slop]:                  https://rubygems.org/gems/slop               "The Slop gem"
[EAH]:                   https://github.com/lbriais/easy_app_helper   "The EasyAppHelper gem"
