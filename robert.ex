defmodule Mymac do
   defmacro test(name) do
     IO.puts " macro test"
     quote do
       IO.puts "code generate from test called by #{unquote(name)}"
     end
   end
end

defmodule MyModule do
  Enum.each [foo: 1, bar: 2, baz: 3], fn { k, v } ->
    IO.puts "mymodule"
    def unquote(k)(arg) do
      unquote(v) + arg
    end
  end
end
defmodule M do
  defmacro my_macro(name) do
    IO.puts 1
    quote bind_quoted: [name: name] do
      IO.puts 4
      def unquote(name)() do
        unquote(IO.puts 2)
        IO.puts "hello #{unquote(name)}"
      end
    end
  end
end

defmodule M2 do
  defmacro my_macro(name) do
    IO.puts 1
    quote do
      IO.puts 5
      def unquote(name)() do
        unquote(IO.puts 2)
        IO.puts "hello #{unquote(name)}"
        unquote(IO.puts 22)
      end
    end
  end
end

defmodule Test do
  @moduledoc """
  Documentation for Robert.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Robert.hello
      :world

  """
  import Mymac
  import M2
  
  #[:foo, :bar]|> Enum.each(&my_macro(&1))
  defmacro mac do
    IO.puts "mac"
  end
  
  def ping do
      receive do
        [from, msg] -> IO.puts "receive #{msg} from #{inspect from}"
      end
      ping()
  end

  def counter(count \\ 0) do
    receive do
      :increase -> counter(count + 1)
      {:get, from} -> 
        send(from, count)
        counter(count)
      _ -> counter(count)
    end
  end

  def hi(times) do
    if times > 0 do
      IO.puts "##{times} I am bigger than 0"
      hi(times - 1)
    end
  end
end