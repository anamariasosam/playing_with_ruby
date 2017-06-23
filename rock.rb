require 'HTTParty'
require 'json'
require 'launchy'

puts 'Which song do you want?
(1) Wild Thoughts
(2) Slow Hands
(3) Im the One
(4) Bad Liar'

while option = gets.chomp.to_i
  case option
  when 1 then
    track_id = '130727382'
    spotify_id = '4IIUaKqGMElZ3rGtuvYlNc'
    break
  when 2 then
    track_id = '129347748'
    spotify_id = '167NczpNbRF7oWakJaY3Hh'
    break
  when 3 then
    track_id = '130727383'
    spotify_id = '72Q0FQQo32KJloivv5xge2'
    break
  when 4 then
    track_id = '129971067'
    spotify_id = '1sCxVKWImDZSZKvG0U9B23'
    break
  else
    puts 'Please select a song'
    print '>'
  end
end

query = {
  'track_id' => track_id,
  'apikey' => 'c4caa5ba22a90e53f85590fdecf2347d'
}

url = 'http://api.musixmatch.com/ws/1.1/track.lyrics.get'
response = HTTParty.get(url, query: query)
Launchy.open("https://open.spotify.com/track/#{spotify_id}")

data = JSON.parse(response.body)
lyric = data['message']['body']['lyrics']['lyrics_body']

def add_line(array, lyric)
  array.each { |e| lyric[e] = '________' }
end

case option
when 1 then add_line(%w[baby wasted thoughts hope], lyric)
when 2 then add_line(%w[said thinking hands leaving], lyric)
when 3 then add_line(%w[money sick only promise], lyric)
when 4 then add_line(%w[street someone rent watch], lyric)
end

puts '**************************************************'
puts '                      LYRIC                       '
puts '**************************************************'

puts lyric

puts '**************************************************'
puts '                   LYRIC END                       '
puts '**************************************************'

puts 'Write the words separated by commas'
words = gets.chomp.split(',')

solution = %w[baby wasted thoughts hope]
guessed = []

solution.each_with_index do |word, index|
  guessed[index] = word == words.fetch(index) ? 1 : 0
end

guessed.each_with_index do |val, index|
  state = val == 1 ? 'correct' : 'incorrect'
  puts "Word number #{index + 1} => #{state} : #{solution.fetch(index)} "
end

puts "Your score is #{guessed.sum}/4"
