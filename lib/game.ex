defmodule Game do
    require Logger
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

        Logger.info "Before play"
        Logger.info "Player1 cards: #{currentcards(player1)}"
        Logger.info "Player2 cards: #{currentcards(player2)}"
        result = oneplay(player1,player2)
        Logger.info "After  play"
        Logger.info "Player1 cards: #{currentcards(player1)}"
        Logger.info "Player2 cards: #{currentcards(player2)}"
        case  result do
            :continue ->
                fullplay(player1,player2)
            :end ->
                Logger.info "game over"
            msg ->
                Logger.info "full play msg #{msg}"
        end
    end

    def oneplay(player1, player2, num_cards \\ 1, cards_left \\ []) do
        {msg,player1_cards} = GenServer.call(player1,{:chupai,num_cards})
        {msg2,player2_cards} = GenServer.call(player2,{:chupai,num_cards})


        if (msg == :ok and msg2 == :ok) do
            player1_cards = player1_cards |> :queue.to_list
            player2_cards = player2_cards |> :queue.to_list
            Logger.info "player1 cards #{player1_cards}"
            Logger.info "player2 cards #{player2_cards}"
            p1 = player1_cards  |> List.last() |> String.slice(1..10) |> String.to_integer()
            p2 = player2_cards  |> List.last() |> String.slice(1..10) |> String.to_integer()
            cond do
                p1 == p2 ->
                    Logger.info "compare again"
                    oneplay(player1, player2, p1, player2_cards ++ player1_cards ++ cards_left)
                p1 > p2 ->
                    GenServer.call(player1,{:yingpai, :queue.from_list(player2_cards ++ player1_cards ++ cards_left)})
                    Logger.info "player1 win"
                    :continue
                p1 < p2 ->
                    Logger.info "Player2 win"
                    GenServer.call(player2,{:yingpai, :queue.from_list(player2_cards ++ player1_cards ++ cards_left)})
                    :continue
            end
        else
            if msg == :error do
                Logger.info "Game over, player1 lost, #{msg}"
            end
            if msg2 == :error do
                Logger.info "Game over, player2 lost, #{msg2}"
            end
            :end
        end
    end

end