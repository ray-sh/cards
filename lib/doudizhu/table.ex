defmodule Ddz.Table do
    '''
    1.The table know all the out cards on the table
    2.The table is response to ask next player to put cards
    '''
    require Logger

    def get_player(players, active_player) do
        elem(players,rem(active_player,(tuple_size(players))))
    end

    def start_game(players, active_player,cards) do
        player =  get_player(players,active_player)
        {:play, new_cards, num_cards_left} = GenServer.call(player,:chupai)
        cards = [ new_cards | cards]
        Logger.info "#{player} chupai #{new_cards} with left cards num #{num_cards_left}"
        Logger.info "cards on table #{cards}"
        case num_cards_left do
            0->
                Logger.info("Game over, winner is #{player}")
            _ ->
                start_game(players, active_player + 1, cards)

        end
    end
end