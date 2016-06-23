require 'sqlite3'
require_relative 'nega_posi_analysis'
require_relative 'acquisition_tweet'

query_string = gets.chomp
agent = Agent.new
result_tweets = agent.get_tweet(query_string)

text_array = []
result_tweets.each do |tweet|
  text_array << tweet.full_text
end

db_name = 'dictionary.db' # データベース名
table_name = 'Dictionary' # データベースのテーブル名
db = SQLite3::Database.new(db_name) # データベースのオブジェクト
noun, verb, adjective, adverb = '名詞', '動詞', '形容詞', '副詞'
sql = "SELECT string, kana, value FROM #{table_name} WHERE p_o_s = ?"
# test_data = db.execute("SELECT p_o_s FROM #{table_name}")
p_o_s_table = {}
p_o_s_table[:noun] = db.execute(sql, noun)
p_o_s_table[:verb] = db.execute(sql, verb)
p_o_s_table[:adjective] = db.execute(sql, adjective)
p_o_s_table[:adverb] = db.execute(sql, adverb)

text_array.each do |text|
  analyzed_data = text_analyze(text)
  value = calculate_value(p_o_s_table, analyzed_data)
  puts "#{value}:#{text}"
end
