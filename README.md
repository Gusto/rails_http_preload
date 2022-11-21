# RailsHttpPreload

Automatically add a `link` header directing clients to `preconnect` to your `asset_host` to HTML document responses in Rails.

This gem is intended a test platform for including a new feature into Rails. As of this writing, this feature has not yet been included in Rails.

The 103 Early Hints status code is intended to allow application developers to signal to the client what critical resources will need to be loaded along with the requested resource. Early Hints can be returned to the client _before_ the actual response. This is much faster than waiting for the server think time to create the actual response.

CDNs can actually implement and serve Early Hints headers to clients without talking to the origin server. CDNs have decided to do this by caching at the point-of-presence (POP) `Link` headers in successful HTTP responses.

CDNs which currently support turning Link headers into Early Hints:

1. Cloudflare
2. Fastly
3. Others?

One possible use of early hints, pioneered by Shopify, is to include a `preload` link to the asset domain, if that domain is not the same as the domain of the request.

For example, before:

1. Client makes request for mydomain.com.
2. 500ms later, client receives 200 response for mydomain.com, and finds a CSS stylesheet at cdn.mydomain.com.
3. Client opens connection to cdn.mydomain.com (200ms)
4. Client downloads CSS stylesheet (200ms) and renders page.

With early hints, we can render this page 200ms faster:

1. Client makes request for mydomain.com.
2. At the CDNs PoP, client receives 103 Early Hint response with a `link` to `preconnect` to `cdn.mydomain.com`.
3. Client opens connection to cdn.mydomain.com while waiting for the 200 response.
4. Client receives 200 response after 500ms.
5. Client downloads CSS stylesheet (200ms) and renders page.

This gem's hypothesis is that **all Rails applications should include a link header to preconnect to the asset host domain if it is not the same as the requested document's domain**.

All this gem does is add this HTTP header to responses for HTML documents. For example, if you have a Rails app that's live at mydomain.com and whose `asset_host` config is at cdn.mydomain.com, we add this header:

```
link: <cdn.mydomain.com>; rel="preconnect"
```

The header is not added for non-HTML responses.

### Best Case Scenario

In the best case scenario, your observed Largest Contentful Paint times should be reduced. The amount will not be predictable, because it depends on how often clients connect to your website with an already-open socket to `cdn.mydomain.com`. Since Chrome and other browsers use socket pools which can keep connections open for a long time, this may happen more often than you think. Or connecting to `cdn.mydomain.com` may not be on the critical path for the Largest Contentful Paint event; i.e. other downloads happening in parallel with setting up that connection are blocking LCP.

### Worst Case Scenario

In the worst case, nothing happens. For example, your CDN doesn't support early hints. No problem, you've just added ~1kb of HTTP headers to your responses, it's basically a no-op. You cannot really create new bugs or bad behavior by including this header.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_http_preload'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rails_http_preload

## Usage

If all you want to add is a header for Rails application's `asset_host`, just add this gem and you're done.

If you would like to add `preconnect` headers to additional URLs, simply configure it in an initializer:

```ruby
RailsHttpPreload.config.additional_urls = %w[https://graphql.mydomain.com https://images.mydomain.com]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gusto/rails_http_preload. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/gusto/rails_http_preload/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the RailsHttpPreload project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/gusto/rails_http_preload/blob/main/CODE_OF_CONDUCT.md).
