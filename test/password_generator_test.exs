defmodule PasswordGeneratorTest do
  use ExUnit.Case
  # doctest PasswordGenerator

  setup do
    options = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "false"
    }

    options_type = %{
      # & <<&1>>>
      lowercase: Enum.map(?a..?z, fn letter -> <<letter>> end),
      numbers: Enum.map(0..9, fn number -> Integer.to_string(number) end),
      uppercase: Enum.map(?A..?Z, fn letter -> <<letter>> end),
      symbols: String.split("~!@#$%%^&*()_+=-{}[]|;:><`,./\"", "", trim: true)
    }

    {:ok, result} = PasswordGenerator.generate(options)

    %{
      options_type: options_type,
      result: result
    }
  end

  test "return a string", %{result: result} do
    assert is_bitstring(result)
  end

  test "return an error when o length is given" do
    options = %{"invalid" => "false"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns an error when o length is not an integer" do
    options = %{"length" => "abc"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "length of returned string is the option provided" do
    length_option = %{"length" => "5"}

    {:ok, result} = PasswordGenerator.generate(length_option)
    assert 5 = String.length(result)
  end

  test "returns a lower case string just with the length", %{options_type: options_type} do
    length_option = %{"length" => "5"}

    {:ok, result} = PasswordGenerator.generate(length_option)

    assert String.contains?(result, options_type.lowercase)

    refute String.contains?(result, options_type.numbers)
    refute String.contains?(result, options_type.uppercase)
    refute String.contains?(result, options_type.symbols)
  end

  test "return error when options values are not boolean" do
    options = %{
      "length" => "10",
      "numbers" => "invalid",
      "uppercase" => "0",
      "symbols" => "false"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "return error when options not allowed" do
    options = %{"length" => "5", "invalid" => "true"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "return error when 1 option not allowed" do
    options = %{"length" => "5", "numbers" => "true", "invalid" => "true"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns a string uppercase", %{options_type: options_type} do
    options_with_uppercase = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "true",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_with_uppercase)

    assert String.contains?(result, options_type.uppercase)

    refute String.contains?(result, options_type.numbers)
    refute String.contains?(result, options_type.symbols)
  end

  test "returns a string just with numbers", %{options_type: options_type} do
    options_with_numbers = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_with_numbers)

    assert String.contains?(result, options_type.numbers)

    refute String.contains?(result, options_type.uppercase)
    refute String.contains?(result, options_type.symbols)
  end

  test "returns a string with uppercase and numbers", %{options_type: options_type} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "true",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options_type.numbers)
    assert String.contains?(result, options_type.uppercase)

    refute String.contains?(result, options_type.symbols)
  end

  test "returns a string symbols", %{options_type: options_type} do
    options_with_uppercase = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_with_uppercase)

    assert String.contains?(result, options_type.symbols)

    refute String.contains?(result, options_type.uppercase)
    refute String.contains?(result, options_type.numbers)
  end

  test "returns a string with uppercase and symbols", %{options_type: options_type} do
    options_included = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "true",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options_type.symbols)
    assert String.contains?(result, options_type.uppercase)

    refute String.contains?(result, options_type.numbers)
  end

  test "returns a string with numbers and symbols", %{options_type: options_type} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options_type.numbers)
    assert String.contains?(result, options_type.symbols)

    refute String.contains?(result, options_type.uppercase)
  end

  test "returns a string with all included options", %{options_type: options_type} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "true",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options_type.numbers)
    assert String.contains?(result, options_type.uppercase)
    assert String.contains?(result, options_type.symbols)
  end
end
