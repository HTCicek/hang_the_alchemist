defmodule Dictionary.WordList do

  def random_word(words) do
    words
    |> Enum.random()
  end
  def word_list do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    # carriage returns because this file was manually added on a windows machine
    |> String.split("\r\n")
  end
end
