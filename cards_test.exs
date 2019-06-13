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
end