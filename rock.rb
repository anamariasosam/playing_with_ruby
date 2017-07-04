# @author Ana Sosa

require 'HTTParty'
require 'json'
require 'launchy'

wild_thoughts = {
  'name' => 'Wild Thoughts',
  'musixmatch_id' => '130727382',
  'spotify_id' => '4IIUaKqGMElZ3rGtuvYlNc',
  'words' => %w[baby wasted thoughts hope]
}

slow_hands = {
  'name' => 'Slow Hands',
  'musixmatch_id' => '129347748',
  'spotify_id' => '167NczpNbRF7oWakJaY3Hh',
  'words' => %w[said thinking hands leaving]
}

the_one = {
  'name' => 'Im the One',
  'musixmatch_id' => '130727383',
  'spotify_id' => '72Q0FQQo32KJloivv5xge2',
  'words' => %w[money sick only promise]
}

bad_liar = {
  'name' => 'Bad Liar',
  'musixmatch_id' => '129971067',
  'spotify_id' => '1sCxVKWImDZSZKvG0U9B23',
  'words' => %w[street someone rent watch]
}

$songs = {
  '1' => wild_thoughts,
  '2' => slow_hands,
  '3' => the_one,
  '4' => bad_liar
}

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
  def initialize(score: 0, words: [], solution: [])
    @score = score
    @words = words
    @solution = solution
  end

  def start
    puts 'Figure out the lyrics of this songs, choose one to start:
    (1) Wild Thoughts
    (2) Slow Hands
    (3) Im the One
    (4) Bad Liar'

    # FIXME: This has crashed when the user does not select a number between 1-4
    create_song(gets.chomp)
  end

  def create_song(selected_song)
    song = $songs[selected_song]

    s = Song.new
    s.name = song['name']
    s.musixmatch_id = song['musixmatch_id']
    s.spotify_id = song['spotify_id']
    s.words = song['words']
    s.play

    @solution = s.words

    print_song(s)
  end

  def print_song(song)
    puts '**************************************************'
    puts song.name.upcase, song.lyric
    puts '**************************************************'
  end

  def write_words
    (1..4).each do |i|
      print "Write the word number #{i}: "
      @words.push(gets.chomp.downcase)
    end
  end

  def guessed
    guessed = []
    @solution.each_with_index do |word, index|
      guessed[index] = word == @words.fetch(index) ? true : false
    end
    guessed
  end

  def result
    guessed.each_with_index do |is_correct, index|
      if is_correct
        result = 'correct'
        @score += 1
      else
        result = "incorrect - the answer is '#{@solution.fetch(index)}'"
      end

      puts "Word number #{index + 1} is #{result}"
    end
    puts "Your score is #{@score}/#{@solution.length}"
  end
end

game = Game.new
game.start
game.write_words
game.result
