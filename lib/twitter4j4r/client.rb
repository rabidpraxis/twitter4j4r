require 'jar/twitter4j-core-3.0.2.jar'
require 'jar/twitter4j-stream-3.0.2.jar'
require 'jar/twitter4j-async-3.0.2.jar'

require 'jruby/core_ext'

require 'twitter4j4r/status_listener'
require 'twitter4j4r/user_stream_listener'
require 'twitter4j4r/site_streams_listener'

module Twitter4j4r
  class Client
    def initialize(auth_map)
      @stream = Java::Twitter4j::TwitterStreamFactory.new(config(auth_map)).instance
      @blocks = {}
    end

    def on_exception(&block)
      on(:exception, block)
    end

    def on_favorite(&block)
      on(:favorite, block)
    end

    def on_limitation(&block)
      on(:limitation, block)
    end

    def on_status(&block)
      on(:status, block)
    end

    def track(*terms, &block)
      on_status(&block)
      start(terms)
    end

    def direct_messages(&block)
      on(:dm, block)
    end

    def on(block_name, block)
      @blocks[block_name] = block
      self
    end

    def start(search_terms)
      @stream.addListener(StatusListener.new(self, @blocks))
      @stream.filter(Java::Twitter4j::FilterQuery.new(0, nil, search_terms.to_java(:string)))
    end

    def userstream
      @stream.addListener(UserStreamListener.new(self, @blocks))
      @stream.user
    end

    def sitestreams(withFollowings, follow)
      @stream.addListener(SiteStreamsListener.new(self, @blocks))
      @stream.site(withFollowings, follow)
    end

    def stop
      @stream.cleanUp
      @stream.shutdown
    end

    protected

    def config(auth_map)
      config = Java::Twitter4jConf::ConfigurationBuilder.new
      config.setDebugEnabled(true)
      config.setPrettyDebugEnabled(true)
      config.setOAuthConsumerKey(auth_map[:consumer_key])
      config.setOAuthConsumerSecret(auth_map[:consumer_secret])
      config.setOAuthAccessToken(auth_map[:access_token])
      config.setOAuthAccessTokenSecret(auth_map[:access_secret])
      config.build
    end
  end
end
