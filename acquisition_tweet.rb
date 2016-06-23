require 'twitter'

class Agent
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'YOUR_CONSUMER_KEY'
      config.consumer_secret = 'YOUR_CONSUMER_SECRET'
      config.access_token = 'YOUR_ACCESS_TOKEN'
      config.access_token_secret = 'YOUR_TWITTER_USERNAME'
    end
  end

  def get_tweet(query_string)
    count = 90
    result_tweets = @client.search(query_string, count: count,
    result_type: 'recent', exclude: 'retweets', since_id: nil, lang: 'ja')
    # take付ける。規制されないように
    result_tweets.take(count)
  end
end
