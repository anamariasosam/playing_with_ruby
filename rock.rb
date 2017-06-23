require 'HTTParty'
require 'json'
require 'launchy'

# Song Class
class Song
  attr_reader :name, :musixmatch_id, :spotify_id, :words
  def initialize(name, musixmatch_id, spotify_id, words)
    @name = name
    @musixmatch_id = musixmatch_id
    @spotify_id = spotify_id
    @words = words
    @lyric = lyric
  end

  def lyric
    url = 'http://api.musixmatch.com/ws/1.1/track.lyrics.get'
    query = {
      'track_id' => @musixmatch_id,
      'apikey' => 'c4caa5ba22a90e53f85590fdecf2347d'
    }
    response = HTTParty.get(url, query: query)
    data = JSON.parse(response.body)

    lyric = data['message']['body']['lyrics']['lyrics_body']

    @words.each { |e| lyric[e] = '________' }

    lyric
  end

  def play
    Launchy.open("https://open.spotify.com/track/#{@spotify_id}")
  end
end

s1 = Song.new('Wild Thoughts',
              '130727382',
              '4IIUaKqGMElZ3rGtuvYlNc',
              %w[baby wasted thoughts hope])

s2 = Song.new('Slow Hands',
              '129347748',
              '167NczpNbRF7oWakJaY3Hh',
              %w[said thinking hands leaving])

s3 = Song.new('Im the One',
              '130727383',
              '72Q0FQQo32KJloivv5xge2',
              %w[money sick only promise])

s4 = Song.new('Bad Liar',
              '129971067',
              '1sCxVKWImDZSZKvG0U9B23',
              %w[street someone rent watch])

songs = { '1' => s1, '2' => s2, '3' => s3, '4' => s4 }

puts 'Which song do you want?
(1) Wild Thoughts
(2) Slow Hands
(3) Im the One
(4) Bad Liar'

song = gets.chomp

puts "**************************************************
          SONG NAME : #{songs[song].name}
**************************************************"

puts songs[song].lyric

puts '**************************************************'
puts '                   LYRIC END                       '
puts '**************************************************'

puts 'Write the words separated by commas'
words = gets.chomp.split(',')
solution = songs[song].words
guessed = []

solution.each_with_index do |word, index|
  guessed[index] = word == words.fetch(index) ? 1 : 0
end

guessed.each_with_index do |val, index|
  state = val == 1 ? 'correct' : 'incorrect'
  puts "Word number #{index + 1} => #{state} : #{solution.fetch(index)} "
end

puts "Your score is #{guessed.sum}/4"
