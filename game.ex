defmodule Game do
    def display do
        receive do
            {player, {:ok, {cards, _}}} ->
                IO.puts "recevie #{cards} from #{player}"
            {player, {:error, msg}} ->
                IO.puts "Game over,#{player} lost, #{msg}"
            msg ->
                IO.puts "unknow message"
                inspect msg
        end
        display()
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
        display = spawn(&display/0)
        send(player1,{:chupai, 1, display})
        send(player2,{:chupai, 1, display})


    end
end