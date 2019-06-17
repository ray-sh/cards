defmodule Game do
    def check do
        receive do
            {player, {:ok, cards_que}} ->
                {cards, _} = cards_que
                IO.puts "recevie #{cards} from #{player}"
                {:ok, cards}
            {player, {:error, msg}} ->
                IO.puts "recevie #{msg} from #{player}"
                {:error,msg}
            msg ->
                IO.puts "unknow message"
                inspect msg
        end
    end

    def currentcards(player) do
        send(player, {:cards, self()})
        receive do
            {:ok, cards} ->
                :queue.to_list(cards)
            msg ->
                msg
            after 1000 ->
                IO.puts "no message return when query cards"
        end
    end
    def fullplay(player1,player2) do
        IO.puts "Before one play"
        IO.puts "Player1 cards: #{currentcards(player1)}"
        IO.puts "Player2 cards: #{currentcards(player2)}"
        result = oneplay(player1,player2)
        IO.puts "After one play"
        IO.puts "Player1 cards: #{currentcards(player1)}"
        IO.puts "Player2 cards: #{currentcards(player2)}"
        case  result do
            :continue ->
                fullplay(player1,player2)
            :end ->
                IO.puts "game over"
            msg ->
                IO.puts "full play msg #{msg}"
        end
    end

    def oneplay(player1, player2, num_cards \\ 1, cards_left \\ []) do
        send(player1,{:chupai, num_cards, self()})
        {msg,player1_cards} = check()
        send(player2,{:chupai, num_cards, self()})
        {msg2,player2_cards} = check()
        if (msg == :ok and msg2 == :ok) do
            p1 = List.last(player1_cards) |> String.last() |> String.to_integer()
            p2 = List.last(player2_cards) |> String.last() |> String.to_integer()
            IO.puts "p1 #{p1} p2 #{p2}"
            cond do
                p1 == p2 ->
                    IO.puts "compare again"
                    oneplay(player1, player2, p1, player2_cards ++ player1_cards ++ cards_left)
                p1 > p2 ->
                    send(player1,{:yingpai, :queue.from_list(player2_cards ++ player1_cards ++ cards_left)})

                    IO.puts "player1 win"

                    :continue
                p1 < p2 ->
                    IO.puts "Player2 win"
                    send(player2,{:yingpai, :queue.from_list(player2_cards ++ player1_cards ++ cards_left)})
                    :continue
            end
        else
            if msg == :error do
                IO.puts "Game over, player1 lost, #{msg}"
            end
            if msg2 == :error do
                IO.puts "Game over, player2 lost, #{msg2}"
            end
            :end
        end
    end

    def start do
        #1.prepare card
        #2.create player1, player2
        #3.prepare cards to player1, player2
        #4.give the card to player1, player2
        #5.start the game by send play command to player1,player2 one by one
        #6.Judge the result and send the cards to the winner or stop the game when one player don't have enough card to play
        cards = Cards.get_cards()
        player1_cards = Enum.slice(cards,0..25) |> :queue.from_list()
        player2_cards = Enum.slice(cards,26..51) |> :queue.from_list()
        player1 = spawn(fn -> Player.play(player1_cards, :player1) end)
        player2 = spawn(fn -> Player.play(player2_cards, :player2) end)


    end
end