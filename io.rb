require_relative 'nega_posi_analysis'
require_relative 'acquisition_tweet'
require_relative 'table_setter'

# 速度の改善考える
p_o_s_table = set_table()

query_string = gets.chomp
agent = Agent.new
result_tweets = agent.get_tweet(query_string)

text_array = []
result_tweets.each do |tweet|
  text_array << tweet.full_text
end

text_array.each do |text|
  analyzed_data = text_analyze(text)
  value = calculate_value(p_o_s_table, analyzed_data)
  puts "#{value}:#{text}"
end
