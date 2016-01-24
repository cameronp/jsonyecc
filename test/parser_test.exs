defmodule ParserTest do
  use ExUnit.Case, async: true
  import Enum

  test "lexes ints" do
    result = Parser.lex("1 -2 3 4")
    assert (result |> map(fn {type, _, _} -> type end)) == [:int,:int,:int,:int]
    assert (result |> map(fn {_, _, val} -> val end)) == [1, -2, 3, 4]
  end

  test "lexes floats" do
    result = Parser.lex("1.0 0.1 -3.1 -0.4 4.0e2 \n -4.0e2")
    assert (result |> map(fn {type, _, _} -> type end) |> all?(fn type -> type  == :float end))
    assert (result |> map(fn {_, _, val} -> val end)) == [1.0, 0.1, -3.1, -0.4, 4.0e2, -4.0e2]
  end

  test "detects non-erlang style floats and sends them through as binaries" do
    result = Parser.lex("1e4 2E4")
    assert (result |> map(fn {type, _, _} -> type end) |> all?(fn type -> type  == :raw_float end))
    assert (result |> map(fn {_, _, val} -> val end)) == ["1e4", "2E4"]
  end

  test "lexes punctuators" do
    result = Parser.lex("[]{}:")
    assert (result |> map(fn {type, _, _} -> type end)) == [:"[", :"]", :"{", :"}", :":"]
  end

  test "skips whitespace" do
    assert (Parser.lex(" \s \t \n ") |> Enum.count) == 0
  end

  test "lexes strings" do
    result = Parser.lex(~s("foo","bar","baz", ""))
    assert(map(result, fn {type, _, _} -> type end) == [:string, :string, :string, :string] )
    assert(map(result, fn {_, _, val} -> val end) == ["foo", "bar", "baz", ""])
  end

  test "lexes booleans" do
    result = Parser.lex(~s(true false))
    assert(map(result, fn {type, _, _} -> type end) == [:boolean, :boolean] )
    assert(map(result, fn {_, _, val} -> val end) == [true, false])
  end

  test "lexes nulls" do
    result = Parser.lex(~s(null))
    assert(map(result, fn {type, _, _} -> type end) == [:null] )
    assert(map(result, fn {_, _, val} -> val end) == [nil])
  end

  test "parses array" do
    result = Parser.parse(~s([1, 2, 3]))
    assert result == [1,2,3]
  end

  test "parses array of arrays" do
    result = Parser.parse(~s([1, [2, 3]]))
    assert result == [1,[2,3]]
  end

  test "parses empty array" do
    result = Parser.parse(~s([]))
    assert result == []
  end

  test "parses object" do
    result = Parser.parse(~s({"foo" : 1, "bar" : 2}))
    assert result == {:object,[{"foo", 1}, {"bar", 2}]}
  end

  test "parses empty object" do
    result = Parser.parse(~s({}))
    assert result == {:object, []}
  end

  test "parses nested objs" do
    result = Parser.parse(~s({"foo" : {"bar": 1}}))
    assert result == {:object, [{"foo", {:object, [{"bar", 1}]}}]}
  end


end
