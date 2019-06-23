defmodule Ddz.Player do
    require Logger
    use GenServer
    '''
    1.The player query the latest card on the table then deceived how to play the cards
    2.The player should check if the cards out are allowed
    '''

    def chupai(cards,num \\1) do
        Enum.take_random(cards,num)
    end

    @impl true
    def init(cards) do
        IO.puts "Player init cards #{cards}"

        {:ok,cards}
    end

    @impl true
    def handle_call(:chupai, _from, cards) do
        Logger.debug "Player current cards #{cards}"
        out_cards = chupai(cards)
        Logger.debug("Player chuapai #{out_cards}")
        {:reply,{:play,out_cards},cards -- out_cards}
    end
end