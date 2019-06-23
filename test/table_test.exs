defmodule TableTest do
    use ExUnit.Case
    alias Ddz.Table
    alias Ddz.Player
    test "Table" do
        assert True
    end

    test "Next player" do
        assert Table.get_player({1,2,3},0) == 1
        assert Table.get_player({1,2,3},1) == 2
        assert Table.get_player({1,2,3},2) == 3
        assert Table.get_player({1,2,3},3) == 1
    end

    test "Table GenServer" do
        {:ok, table} = GenServer.start_link(Table,[{},nil,[]])

        {:ok,player1} = GenServer.start_link(Ddz.Player,[1,2,3])
        {:ok,player2} = GenServer.start_link(Player,[4,5,6])
        {:ok,player3} = GenServer.start_link(Player,[7,8,9])

        :ok = GenServer.call(table,{:join, player1})
        :ok = GenServer.call(table,{:join, player2})
        :ok = GenServer.call(table,{:join, player3})
        :error_table_full = GenServer.call(table,{:join, player3})

        GenServer.cast(table,:start)

        :timer.sleep 5_000

    end
end