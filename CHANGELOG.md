# Sculpt Changelog

Take a look here for updates on what's changed/changing in Sculpt.

## 22/07/12 - v0.1.05

New option: `Sculpt.smart_attrs` in response to issue #2.

This option is true by default, and will replace underscores with hyphens in any attribute **key** that is also a **symbol**.

The reasoning behind this is that symbols can't have hyphens in, but hyphens are often used in attribute keys (e.g. data-foo). So, in order to preserve the nice sym-based hash syntax introduced in Ruby 1.9 (`key: "value"` instead of `"key" => "value"`), Sculpt will now automatically replace underscores in your attribute keys with hyphens **only if they are syms**.

This is important as it means you can still have keys with underscores in, just by using a string instead of a symbol.

Here is an example of the changes applied:

```ruby
Sculpt.render do
	# using a sym key with underscores
	p "moo", data_animal: "cow" # => <p data-animal="cow">moo</p>
	
	# note attr values are not affected, just keys
	p "woof", data_animal: :a_dog # => <p data-animal="a_dog">woof</p>
	
	# note string keys are also unaffected
	p "quack", "data_animal" => "duck" # => <p data_animal="duck">quack</p>
end
```

You can of course completely disable the new option:

```ruby
Sculpt.smart_attrs = false
Sculpt.render do
	p "moo", data_animal: "cow" # => <p data_animl="cow">moo</p>
end
```

## 28/06/12 - v0.1.04

The Sculpt class methods now support code supplied as a string as well as a block.
For example:

```ruby
Sculpt.render do
	p "hi"
end

# is the same as

Sculpt.render('p "hi"')
```

Thanks to a handy helper, `String#to_proc`, which you can find in `lib/sculpt/sculpt_helpers.rb`.

## 23/06/12 - v0.1.03

Introducing Funky classes. Why are they funky? Take a look:

```ruby
Sculpt.render do
	img.framed.round "the_lolcat.png" # => <img src="the_lolcat.png" class="framed round">	
end
```

Just like CSS! - Aren't dynamic methods great?

## Planned Changes

 - HTML escaping.
 - Add support for some kind of special syntax for IDs (that will be difficult).