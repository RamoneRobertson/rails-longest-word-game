require "json"
require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)
  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'...'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    cache = ActiveSupport::Cache::MemoryStore.new
    cache.read('score')
    @letters = params[:letters].split
    @word = params[:word]
    @in_grid = in_grid(@word)
    @valid = is_valid?(@word)
    @score = @word.chars.count * 10
    @total_score += @score
  end

  private
  def in_grid(word)
    word.chars.all? { |letter| word.count(letter) <= @letters.count(letter) }
  end

  def is_valid?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    page = URI.parse(url).read
    json_result = JSON.parse(page)
    # Do not to explicitly write return: The api response will be tru or false
    json_result["found"]
  end
end