defmodule CardsTest do
    use ExUnit.Case
    test "xipai" do
        {:ok, pid} = GenServer.start_link(Cards,nil)
        assert pid
        GenServer.cast(pid,:xipai)
        GenServer.cast(pid,:xipai)
        cards = GenServer.call(pid,:left_cards)
        assert Enum.sort(Cards.get_cards()) == Enum.sort(cards)
    end

    test "fapai" do
        {:ok, pid} = GenServer.start_link(Cards,nil)
        assert pid
        Enum.each(1..53, fn i ->
            cards = GenServer.call(pid,:fapai)
            case cards do
                [] ->
                    assert i == 53
                [card | []] ->
                    assert card
            end
        end)
    end

    test "chupai" do
        {:ok, player} = GenServer.start_link(Player,:queue.from_list([1,2,3]))
        {:ok,cards} = GenServer.call(player, {:chupai,1})
        assert cards |> :queue.to_list == [1]


        {:ok, player} = GenServer.start_link(Player,:queue.from_list([1,2,3]))
        {:ok,cards} = GenServer.call(player, {:chupai,2})
        assert cards |> :queue.to_list == [1,2]

        {:ok, player} = GenServer.start_link(Player,:queue.from_list([1,2,3]))
        {:ok,cards} = GenServer.call(player, {:chupai,3})
        assert cards |> :queue.to_list == [1,2,3]

        {:ok, player} = GenServer.start_link(Player,:queue.from_list([1,2,3]))
        {:error,msg} = GenServer.call(player, {:chupai,4})
        IO.puts msg

        {:ok, player} = GenServer.start_link(Player,:queue.from_list([1,2,3]))
        {:error,msg} = GenServer.call(player, {:chupai,0})
        IO.puts msg

        {:ok, player} = GenServer.start_link(Player,:queue.from_list([]))
        {:error,msg} = GenServer.call(player, {:chupai,0})
        IO.puts msg

    end

    test "yingpai" do
        cards = Player.yingpai(:queue.from_list([1,2,3]),:queue.from_list([4,5]))
        assert cards |> :queue.to_list == [1,2,3,4,5]
    end

    test "one round test" do
        cards = Cards.get_cards()
        player1_cards = Enum.slice(cards,0..25) |> :queue.from_list()
        player2_cards = Enum.slice(cards,26..51) |> :queue.from_list()
        player1 = spawn(fn -> Player.play(player1_cards, :player1) end)
        player2 = spawn(fn -> Player.play(player2_cards, :player2) end)
        Game.oneplay(player1,player2,1)
        Game.oneplay(player1,player2,10)
        Game.oneplay(player1,player2,2)
    end

    test "full play" do
        cards = Cards.get_cards()
        player1_cards = Enum.slice(cards,0..25) |> :queue.from_list()
        player2_cards = Enum.slice(cards,26..51) |> :queue.from_list()
        player1 = spawn(fn -> Player.play(player1_cards, :player1) end)
        player2 = spawn(fn -> Player.play(player2_cards, :player2) end)
        Game.fullplay(player1,player2)
    end
end