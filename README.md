# moonshine_modspdy

This plugin will install and configured mod_spdy for Apache and enable it.  There are currently no configuration options, so all you need to do is install the plugin and add this to your application manifest:

<pre><code>
recipe :spdy
</code></pre>

And that's it!

## moonshine_spdy and moonshine_haproxy

If you're using moonshine_haproxy and have SSL enabled, you just need to add the spdy recipe to your haproxy manifest and it should just *magically* work.