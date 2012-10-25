require 'jar/twitter4j-stream-2.2.6.jar'

module Twitter4j4r
  class UserStreamListener
    include Java::Twitter4j::UserStreamListener

    def initialize(client, dm_block, exception_block)
      @client = client
      @dm_block = dm_block
      @exception_block = exception_block
    end

    def onException(exception)
      call_block_with_client(@exception_block, exception)
    end

    def onDirectMessage(message)
      call_block_with_client(@dm_block, message)
    end

    protected
    def call_block_with_client(block, *args)
      block.call(*((args + [@client])[0, block.arity])) if block
    end
  end
end
