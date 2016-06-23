require 'natto'



# 入力されたテキストを名詞、動詞、形容詞、副詞に分解してハッシュで返す。
def text_analyze(text)
  nm = Natto::MeCab.new
  noun_words, adjective_words, verb_words, adverb_words = [], [], [], []
  nm.parse(text) do |n|
    word = n.surface
    # p_o_sはpart of speechの略、意味は品詞
    p_o_s = n.feature.split(',')[0]
    # 名詞、動詞、形容詞、副詞のみを取り出す
    if p_o_s == '名詞'
      noun_words << word
    elsif p_o_s == '動詞'
      verb_words << word
    elsif p_o_s == '形容詞'
      adjective_words << word
    elsif p_o_s == '副詞'
      adverb_words << word
    end
  end
  { noun: noun_words, adjective: adjective_words,
  verb: verb_words, adverb: adverb_words}
end

# テーブル、text_analyzeメソッドの戻り値を入力値として、感情の値を返す。
def calculate_value(table, analyzed_data)
  answer = {}
  # tableは品詞をキーとしたハッシュ、中身は2次元配列となっている。2次元配列は辞書の品詞を除いたもの
  table.each_key do |key|
    answer[key] = []
    analyzed_data[key].each do |word|
      table[key].size.times do |i|
         answer[key] << i if table[key][i].find { |n| n == word }
      end
    end
  end
  sum_of_positive_number, sum_of_negative_number = 0, 0
  avg_of_positive_number, avg_of_negative_number = 0, 0
  num_of_positive, num_of_negative = 0, 0
  answer.each do |key, value|
    value.each do |i|
      # 感情の値を代入
      temp_value = table[key][i][2]
      # ポジティブとネガティブ別々に集計
      if temp_value > 0
        sum_of_positive_number += temp_value
        num_of_positive += 1
      elsif temp_value < 0
        sum_of_negative_number += temp_value
        num_of_negative += 1
      end
    end
  end
=begin
感情極性対応表のデータに偏りがある（ポジティブの単語とネガティブの単語の数に大きな差がある）
そのため、ポジティブはポジティブで平均値を出し、
ネガティブはネガティブで平均値を出し、それらを足しあわせて2で割っている。
単純に足しあわせて割るようにした場合には結果がネガティブに偏ると思われる。
=end
  if sum_of_positive_number != 0
    avg_of_positive_number = sum_of_positive_number / num_of_positive
  end

  if sum_of_negative_number != 0
    avg_of_negative_number = sum_of_negative_number / num_of_negative
  end
  avg = (avg_of_positive_number + avg_of_negative_number) / 2
  avg
end
