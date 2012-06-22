# Sculpt Changelog

Take a look here for updates on what's changed/changing in Sculpt.

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