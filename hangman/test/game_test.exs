defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game returns struct" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "Game.letters contains only lower-case ASCII" do
    game = Game.new_game()

    assert game.letters
           |> Enum.all?(fn l -> l =~ ~r([a-z]) end)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game =
        Game.new_game()
        |> Map.put(:game_state, state)

      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence of letter is not already used" do
    game = Game.new_game
    game = Game.make_move(game, "x")
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wonky")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a good guessed word is a won game" do
    game = Game.new_game("wonky")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    game = Game.make_move(game, "o")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    game = Game.make_move(game, "n")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    game = Game.make_move(game, "k")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    game = Game.make_move(game, "y")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "a bad guess is recognized" do
    game = Game.new_game("wonky")
    game = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "a bad guess with 1 turn left is recognized as a loss" do
    game = Game.new_game("wonky")
    game = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
    game = Game.make_move(game, "t")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5
    game = Game.make_move(game, "e")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4
    game = Game.make_move(game, "q")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3
    game = Game.make_move(game, "u")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2
    game = Game.make_move(game, "p")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1
    game = Game.make_move(game, "l")
    assert game.game_state == :lost
  end
end
