defmodule Ddz.Table do
    '''
    1.The table know all the out cards on the table
    2.The table is response to ask next player to put cards
    '''
    require Logger
    use GenServer

    def get_player(players, active_player) do
        elem(players,rem(active_player,(tuple_size(players))))
    end

    def start_game(players, active_player,cards) do
        #TODO:
        player =  get_player(players,active_player)
        {:play,new_cards} = GenServer.call(player,:chupai)

    end

    @impl true
    def init(_) do
        {:ok, [{}, nil, []]}
    end
    
    @impl true
    def handle_call({:join, player}, _from, [players, active_player, cards]) do
        case tuple_size(players) do
            0 ->
                {:reply,:ok,[Tuple.append(players,player), 0, cards]}
            1 ->
                {:reply,:ok,[Tuple.append(players,player), active_player, cards]}
            2 -> 
                {:reply,:ok,[Tuple.append(players,player), active_player, cards]}
            _ ->
                {:reply,:error_table_full, [players, active_player, cards]}

        end
    end
end