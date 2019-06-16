defmodule CardsTest do
    use ExUnit.Case
    test "xipai" do
        cards = spawn(&Cards.start/0)
        assert is_pid(cards)
        send(cards,:xipai)
        send(cards,:xipai)
        send(cards,{:left_cards, self()})
        receive do
            msg ->
                assert Enum.sort(Cards.get_cards()) == Enum.sort(msg)
            after
                5000 ->
                    IO.puts :stderr, "no meesaage received in 5 seconds"
        end
    end

    test "fapai" do
        cards = spawn(&Cards.start/0)
        Enum.each(1..53, fn i ->
            send(cards,{:fapai, self()})
            receive do
                {:ok, card} -> 
                    assert card
                {:error,msg} ->
                    assert i == 53
                    assert msg == "There is no cards left"
                    assert false, "This shouldn't happen"
            end
        end)
    end

    test "chupai" do
        {:ok, cards, cards_left} = Player.chupai(:queue.from_list([1,2,3]))
        assert cards |> :queue.to_list == [1]
        assert cards_left |> :queue.to_list == [2,3]

        {:ok, cards, cards_left} = Player.chupai(:queue.from_list([1,2,3]),2)
        assert cards |> :queue.to_list == [1,2]
        assert cards_left |> :queue.to_list == [3]

        {:ok, cards,cards_left} = Player.chupai(:queue.from_list([1,2,3]),3)
        assert cards |> :queue.to_list == [1,2,3]
        assert cards_left |> :queue.to_list == []

        {:error, msg} = Player.chupai(:queue.from_list([1,2,3]),4)
        IO.puts msg
        
        {:error, msg} = Player.chupai(:queue.from_list([1,2,3]),0)
        IO.puts msg
        
        {:error, msg} = Player.chupai(:queue.from_list([]),0)
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