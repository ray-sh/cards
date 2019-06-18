defmodule Game do

    def currentcards(player) do
        {:ok, cards} = GenServer.call(player,{:cards})
        :queue.to_list(cards)
    end

    def fullplay(player1,player2) do
        #1.prepare card
        #2.create player1, player2
        #3.prepare cards to player1, player2
        #4.give the card to player1, player2
        #5.start the game by send play command to player1,player2 one by one
        #6.Judge the result and send the cards to the winner or stop the game when one player don't have enough card to play

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
        {msg,player1_cards} = GenServer.call(player1,{:chupai,num_cards})
        {msg2,player2_cards} = GenServer.call(player2,{:chupai,num_cards})


        if (msg == :ok and msg2 == :ok) do
            player1_cards = player1_cards |> :queue.to_list
            player2_cards = player2_cards |> :queue.to_list
            IO.puts "player1 cards #{player1_cards}"
            IO.puts "player2 cards #{player2_cards}"
            p1 = player1_cards  |> List.last() |> String.slice(1..10) |> String.to_integer()
            p2 = player2_cards  |> List.last() |> String.slice(1..10) |> String.to_integer()
            IO.puts "p1 #{p1} p2 #{p2}"
            cond do
                p1 == p2 ->
                    IO.puts "compare again"
                    oneplay(player1, player2, p1, player2_cards ++ player1_cards ++ cards_left)
                p1 > p2 ->
                    GenServer.call(player1,{:yingpai, :queue.from_list(player2_cards ++ player1_cards ++ cards_left)})
                    IO.puts "player1 win"
                    :continue
                p1 < p2 ->
                    IO.puts "Player2 win"
                    GenServer.call(player2,{:yingpai, :queue.from_list(player2_cards ++ player1_cards ++ cards_left)})
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

end