require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    user_answer = params[:word]
    grid = params[:letters].split(" ")
    @result = ""
    if in_grid(user_answer.chars, grid)
      word_check(user_answer) ? @result = "Congratulations #{user_answer.upcase} is a valid English word" :
      @result = "Sorry but #{user_answer.upcase} does not seem to be a valid English word..."
      # @result = "Congratulations #{user_answer.upcase} is in the grid"
    else
      @result = "Sorry but, #{user_answer.upcase} can't be built out of #{params[:letters].upcase}"
    end
  end

  private
  def in_grid(word, grid)
    word.all? {|letter| word.count(letter) <= grid.count(letter)}
  end

  def word_check(word)
    url = "https://dictionary.lewagon.com/#{word}"
    @word_desc = JSON.parse(URI.open(url).read)
    @valid = @word_desc["found"]
  end
end
