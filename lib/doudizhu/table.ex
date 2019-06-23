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

    @impl true
    def init([players, active_player, cards]) do
        {:ok, [players, active_player, cards]}
    end

    @impl true
    def handle_cast({:play,new_cards}, [players, active_player, cards]) do
        Logger.debug ":play #{new_cards}"
        GenServer.call(get_player(players,active_player),:chupai)
        {:noreply,[players, active_player+1,[new_cards|cards]]}
    end

    @impl true
    def handle_cast(:start,[players, active_player, cards]) do
        Logger.info "table start"
        Logger.debug("start from player #{active_player}")
        GenServer.call(get_player(players,active_player),:chupai)
        {:noreply,[players, active_player+1, cards]}
    end

    @impl true
    def handle_call({:play,:skip},_from,[players, active_player, cards]) do
        GenServer.call(get_player(players,  active_player),:chupai)
        {:noreply,[players, active_player+1,cards]}
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