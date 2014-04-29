# moonshine_modspdy

This plugin will install and configured mod_spdy for Apache and enable it.  There are currently no configuration options, so all you need to do is install the plugin and add this to your application manifest:

<pre><code>
recipe :spdy
</code></pre>

And that's it!

## moonshine_spdy and moonshine_haproxy

If you're using moonshine_haproxy and have SSL enabled, you just need to add the spdy recipe to your haproxy manifest and it should just *magically* work.

## Warning

We've run into some issues with older clients (Net::HTTP in Ruby 1.9.3) not being able to request SSL URLs from sites with mod_spdy.  If you don't care about that, then feel free to use this plugin. If you SSL-protect your API or use something like Scout or nagios to monitor SSL-enabled URLs, you might want to hold off.

## Copyright

Unless otherwise specified, all content copyright &copy; 2014, [Rails Machine, LLC](http://railsmachine.com)
