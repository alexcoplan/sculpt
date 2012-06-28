# Sculpt Changelog

Take a look here for updates on what's changed/changing in Sculpt.

## 28/06/12 - v0.1.04

The Sculpt class methods now support code supplied as a string as well as a block.
For example:

```ruby
Sculpt.render do
	p "hi"
end

# is the same as
```ruby
Sculpt.render('p "hi"')
```

Thanks to a handy helper, String#to_proc, which you can find in `lib/sculpt/sculpt_helpers.rb`.

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