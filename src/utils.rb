def strip_js(data)
  non_empty_strings = []
  stripped_data     = data.gsub(/('|").*?[^\\]\1/) { |m|
    non_empty_strings.push $&
    "!temp-string-replacement-#{non_empty_strings.size}!"
  }
  stripped_data.gsub(/\/\*.*?\*\//m, "\n").gsub(/\/\/.*$/, "").gsub(/( |\t)+$/, "").gsub(/\n+/, "\n").gsub(/!temp-string-replacement-([0-9]+)!/) { |m| non_empty_strings[$1.to_i] }
end


def word_freq_in the_file
  store = Hash.new
  the_file.each_line { |line|
    line.split.each { |word| store.has_key?(word) ? store[word] += 1 : store[word] = 1 }
  }
  store.sort { |a, b| a[1]<=>b[1] }
  store
end