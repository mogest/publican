# Publican

A super-simple subscribe/publish library for your Ruby objects.

Often you want to let your caller know what happened in your method call. You might return a symbol or custom-made
Struct, and expect your caller to use a `case` statement to work out what happened.  The problem is that if you
return a symbol the caller isn't expecting, or if the caller types in the symbol incorrectly, they might not handle
it correctly.

Another traditional way to handle this is to make an exception classes for every outcome.  That's pretty
code-heavy, and it doesn't let you notify that multiple events happened either.

Enter Publican.  Your method can publish events for its callers to listen to, with as much additional data as you
like.  You can publish as many events as you like, as well as progress upgrades if it's long-running.  You can have
multiple listeners.  You can also guarantee that your callers are listening for important events.

## Installing Publican

`gem install publican` or add it to your `Gemfile`.

## Using Publican

Publican can just be `include`d into a class.  By doing so, it adds one public method, `on`, and two protected
methods, `publish` and `publish!`.

Here's an example of Publican in use.  An ideal use case is a service class:

```ruby
class SaveImage
  include Publican

  def call(image)
  	if image.width < 300
      publish!(:invalid_size, "Image must be at least 300 pixels wide")
	  return
	end

	if image.height < 300
	  image.resize!(height: 300)
	  publish(:resized)
	end

	File.write("image_data/#{image.id}", image.data)
	publish(:success)
  end
end
```

You'll notice that, instead of using return values, we're publishing events for our subscribers to hear.

Here's some code that uses our Publican-powered service:

```ruby
SaveImage
  .new
  .on(:invalid_size) { |error| puts "Error: #{error}" }
  .on(:resized)      { puts "The image was resized" }
  .on(:success)      { puts "Everything was awesome!" }
  .call(image)
```

Or maybe you'd like to use the same service in your Rails app?  No problem.

```ruby
class ImagesController < ApplicationController
  def create
    image = Image.find(params[:id])

	SaveImage
	  .new
	  .on(:invalid_size) { |error| flash.alert = "Error: #{error}" }
	  .on(:success)      { flash.notice = "Image successfully saved." }
	  .call(image)

	redirect_to root_path
  end
end
```

Note that the above example doesn't listen to the `:resized` event.  That's OK, because the event was published
with the `publish` method, not `publish!`.  What's the difference?  See the next section.

## publish vs publish!

`publish` sends out your event and doesn't care whether anyone's listening.

`publish!` ensures at least something is listening to the event, otherwise it'll raise
a `Publican::NoListenersError` exception.  This is useful when you want to ensure some action is taken on the
event occurring.

## Licence and Copyright

Copyright Powershop New Zealand Limited and Roger Nesbitt.  MIT licence.
