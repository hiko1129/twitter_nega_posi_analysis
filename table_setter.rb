require 'sqlite3'

def set_table
  db_name = 'dictionary.db' # データベース名
  db = SQLite3::Database.new(db_name) # データベースのオブジェクト
  sql = "SELECT * FROM Noun"
  # test_data = db.execute("SELECT p_o_s FROM #{table_name}")
  p_o_s_table = {}
  p_o_s_table[:noun] = db.execute(sql)
  sql.sub!(/Noun/, 'Verb')
  p_o_s_table[:verb] = db.execute(sql)
  sql.sub!(/Verb/, 'Adjective')
  p_o_s_table[:adjective] = db.execute(sql)
  sql.sub!(/Adjective/, 'Adverb')
  p_o_s_table[:adverb] = db.execute(sql)
  p_o_s_table
end
