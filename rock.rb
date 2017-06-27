require 'HTTParty'
require 'json'
require 'launchy'

# Song Class
class Song
  attr_accessor :name, :musixmatch_id, :spotify_id, :words

  def lyric
    url = 'http://api.musixmatch.com/ws/1.1/track.lyrics.get'
    query = {
      'track_id' => @musixmatch_id,
      'apikey' => 'c4caa5ba22a90e53f85590fdecf2347d'
    }

    response = HTTParty.get(url, query: query)
    data = JSON.parse(response.body)

    lyric = data['message']['body']['lyrics']['lyrics_body']

    @words.each { |e| lyric[e] = '_' * e.length }

    lyric
  end

  def play
    Launchy.open("https://open.spotify.com/track/#{@spotify_id}")
  end
end

# Game Class
class Game
  def initialize(score: 0)
    @score = score
  end
end

puts 'Which song do you want?
(1) Wild Thoughts
(2) Slow Hands
(3) Im the One
(4) Bad Liar'

selected_song = gets.chomp.to_i

song = Song.new
case selected_song
when 1
  song.name = 'Wild Thoughts'
  song.musixmatch_id = '130727382'
  song.spotify_id = '4IIUaKqGMElZ3rGtuvYlNc'
  song.words = %w[baby wasted thoughts hope]
when 2
  song.name = 'Slow Hands'
  song.musixmatch_id = '129347748'
  song.spotify_id = '167NczpNbRF7oWakJaY3Hh'
  song.words = %w[said thinking hands leaving]
when 3
  song.name = 'Im the One'
  song.musixmatch_id = '130727383'
  song.spotify_id = '72Q0FQQo32KJloivv5xge2'
  song.words = %w[money sick only promise]
when 4
  song.name = 'Bad Liar'
  song.musixmatch_id = '129971067'
  song.spotify_id = '1sCxVKWImDZSZKvG0U9B23'
  song.words = %w[street someone rent watch]
end

puts "**************************************************
          SONG NAME: #{song.name}
**************************************************"

puts song.lyric

puts '**************************************************'
puts '                   LYRIC END                       '
puts '**************************************************'

print 'Write the words separated by commas: '
words = gets.chomp.split(',')

guessed = []

song.words.each_with_index do |word, index|
  guessed[index] = word == words.fetch(index) ? 1 : 0
end

guessed.each_with_index do |val, index|
  state = val == 1 ? 'correct' : 'incorrect'
  puts "Word number #{index + 1} => #{state} : #{song.words.fetch(index)} "
end

puts "Your score is #{guessed.sum}/4"
