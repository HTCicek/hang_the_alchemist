defmodule Dictionary do
  def random_word do
    word_list()
    |> Enum.random()
  end
  def word_list do
    "assets/words.txt"
    |> File.read!()

    # carriage returns because this file was manually added on a windows machine
    |> String.split("\r\n")
  end
end
