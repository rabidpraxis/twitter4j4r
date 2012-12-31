module Twitter4j4r
  class SiteStreamsListener
    include Java::Twitter4j::SiteStreamsListener

    def initialize(client, blocks)
      @client = client
      @blocks = blocks
    end

    [[ :onException,               :exception ],
     [ :onDeletionNotice,          :delete ],
     [ :onBlock,                   :block ],
     [ :onDirectMessage,           :dm ],
     [ :onFriendList,              :friend_list ],
     [ :onFavorite,                :favorite ],
     [ :onFollow,                  :follow ],
     [ :onUnblock,                 :unblock ],
     [ :onUnfavorite,              :unfavorite ],
     [ :onUserListCreation,        :user_list_creation ],
     [ :onUserListDeletion,        :user_list_deletion ],
     [ :onUserListMemberAddition,  :user_list_member_addition ],
     [ :onUserListMemberDeletion,  :user_list_member_deletion ],
     [ :onUserListSubscription,    :user_list_subscription ],
     [ :onUserListUnsubscription,  :user_list_unsubscription ],
     [ :onUserListUpdate,          :user_list_update ],
     [ :onUserProfileUpdate,       :user_profile_update ],
     [ :onDisconnectionNotice,     :stream_disconnect ]
    ].each do |method|
      define_method(method[0]) do |*args|
        call_block_with_client(method[1], *args)
      end
    end

    protected

    def call_block_with_client(block_key, *args)
      if block = @blocks[block_key]
        block.call(*((args + [@client])[0, block.arity]))
      end
    end
  end
end
