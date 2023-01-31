defmodule PasswordGenerator do
  @moduledoc """
  Generates random password depending on parameters, Module main function is `generate(options)`.
  That function takes the options map.
  Options example:
    options = %{
      "length" => "10",
      "numbers" => "invalid",
      "uppercase" => "0",
      "symbols" => "false"
    }
  The options are only 4, `length`, `numbers`, `uppercase` and `symbols`.
  """

  @allowed_options [:length, :numbers, :uppercase, :symbols]
  @symbols "~!@#$%%^&*()_+=-{}[]|;:><`,./\""

  @doc """
  Generates a password for the given options:


  ## Examples
      options = %{
      "length" => "10",
      "numbers" => "invalid",
      "uppercase" => "0",
      "symbols" => "false"
    }
      iex> PasswordGenerator.generate(options)
      abcd3

  """

  @spec generate(options :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  def generate(options) do
    length = Map.has_key?(options, "length")

    validate_length(length, options)
  end

  defp validate_length(false, _options), do: {:error, "Please provide a length"}

  defp validate_length(true, options) do
    numbers = Enum.map(0..9, fn number -> Integer.to_string(number) end)
    length = options["length"]
    length = String.contains?(length, numbers)

    valid_length_is_integer(length, options)
  end

  defp valid_length_is_integer(false, _options) do
    {:error, "Only integer allowed length"}
  end

  defp valid_length_is_integer(true, options) do
    length =
      options["length"]
      |> String.trim()
      |> String.to_integer()

    options_without_length = Map.delete(options, "length")
    options_value = Map.values(options_without_length)

    value =
      Enum.all?(options_value, fn option_value -> String.to_atom(option_value) |> is_boolean() end)

    validate_options_values_are_boolean(value, length, options_without_length)
  end

  defp validate_options_values_are_boolean(false, _length, _options) do
    {:error, "Only booleans allowed for options values"}
  end

  defp validate_options_values_are_boolean(true, length, options) do
    options = included_options(options)
    invalid_options? = Enum.any?(options, fn option -> option not in @allowed_options end)
    validate_options(invalid_options?, length, options)
  end

  defp included_options(options) do
    filtered_options =
      Enum.filter(options, fn {_key, value} ->
        value |> String.trim() |> String.to_existing_atom()
      end)

    Enum.map(filtered_options, fn {key, _value} -> String.to_atom(key) end)
  end

  defp validate_options(true, _length, _options) do
    {:error, "Only options allowed numbers, uppercase and symbols"}
  end

  defp validate_options(false, length, options) do
    generate_strings(length, options)
  end

  defp generate_strings(length, options) do
    options = [:lowercase_letter | options]
    included = include(options)
    length = length - length(included)

    random_strings = generate_random_strings(length, options)
    strings = included ++ random_strings
    get_result(strings)
  end

  defp include(options) do
    Enum.map(options, fn option -> get(option) end)
  end

  defp get(:lowercase_letter) do
    <<Enum.random(?a..?z)>>
  end

  defp get(:uppercase) do
    <<Enum.random(?A..?Z)>>
  end

  defp get(:numbers) do
    random_number = Enum.random(1..9)
    Integer.to_string(random_number)
  end

  defp get(:symbols) do
    symbols = String.split(@symbols, "", trim: true)
    Enum.random(symbols)
  end

  defp generate_random_strings(length, options) do
    Enum.map(1..length, fn _ -> get(Enum.random(options)) end)
  end

  defp get_result(strings) do
    string =
      strings
      |> Enum.shuffle()
      |> to_string()

    {:ok, string}
  end
end
