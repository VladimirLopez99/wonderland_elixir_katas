defmodule AlphabetCipher.Coder do
    @doc """
    Function that encondes something
  """
  def encode(keyword, message) do
    alphabet()
    |> get_columns(keyword)
    |> get_combinations(message)
    |> get_secret_letters()
    |> Enum.join()
  end

  defp alphabet do
    "abcdefghijklmnopqrstuvwxyz" |> String.codepoints()
  end

  defp get_columns(alphabet, keyword) do
    keyword
    |> String.duplicate(div(length(alphabet), String.length(keyword)) + 2)
    |> String.split("", trim: true)
  end

  defp get_combinations(columns, message) do
    columns
    |> Enum.zip(String.split(message, "", trim: true))
  end

  defp get_secret_index(a, b) do
    Enum.find_index(alphabet(), fn x -> x == a end) - length(alphabet()) +
      Enum.find_index(alphabet(), fn x -> x == b end)
  end

  defp get_secret_letters(combinations) do
    # [{"", ""}, {"", ""}, {"", ""}]
    combinations
    |> Enum.map(fn {letter_of_keyword, letter_of_message} ->
      secret_index = get_secret_index(letter_of_keyword, letter_of_message)

      Enum.at(alphabet(), secret_index)
    end)
  end

  def decode(keyword, message) do
    alphabet()
    |> get_columns(keyword)
    |> get_combinations(message)
    |> get_sec_letters()
    |> Enum.join()
  end

  defp turned_secret_index(a, b) do
    Enum.find_index(alphabet(), fn x -> x == b end) -
      Enum.find_index(alphabet(), fn x -> x == a end) 
  end

  defp get_sec_letters(combinations) do
    # [{"", ""}, {"", ""}, {"", ""}]
    combinations
    |> Enum.map(fn {letter_of_keyword, letter_of_message} ->
      secret_index = turned_secret_index(letter_of_keyword, letter_of_message)

      Enum.at(alphabet(), secret_index)
    end)
  end

  def decipher(cipher, message) do
    cipher
    |> apply_func_list_tuples(message)
    |> output_message()
  end

  defp output_message(phrase) do
    Enum.reduce_while(phrase,"", fn x, acc -> 
      if acc != List.to_string(return_list(phrase, acc)), 
      do: {:cont, acc = acc <> x}, 
      else: {:halt, acc} end)
  end

  defp apply_func_list_tuples(cipher, message) do
    Enum.map(
      merge_tuples(cipher, message), 
      fn {a,b} ->
        Enum.at(alphabet(), turned_secret_index(b,a))
    end)
  end

  defp merge_tuples(cipher, message) do
    Enum.zip(String.split(cipher, "", trim: true), String.split(message, "", trim: true))
  end

  defp return_list(phrase, acc) do
    Enum.slice(phrase, String.length(acc)..(String.length(acc)*2-1))
  end

end