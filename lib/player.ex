defmodule Player do
    use GenServer
    #all cards are :queue type
    @empyt_que :queue.new()
    def chupai(cards_in_hand,num \\ 1,out_cards \\ @empyt_que)
    def chupai(@empyt_que,_,_), do: {:error, "There are zero cards left"}
    def chupai(_,0,_), do: {:error, "it's strange to ask zero cards"}
    def chupai(cards_in_hand,1,out_cards) do
        {{:value, card}, cards_in_hand} = :queue.out(cards_in_hand)
        {:ok, :queue.in(card,out_cards),cards_in_hand}
    end

    def chupai(cards_in_hand,num,out_cards) do
        #all cards are :queue type
        if :queue.len(cards_in_hand) < num do
            {:error, "There are only #{:queue.len(cards_in_hand)} cards in hand"}
        else
            {{:value, card}, que} = :queue.out(cards_in_hand)
            chupai(que,num-1,:queue.in(card,out_cards))
        end
    end

    def yingpai(cards_in_hand, new_cards) do
        #all cards are :queue type
        :queue.join(cards_in_hand,new_cards)
    end

    @impl true
    def init(cards) do
        {:ok, cards}
    end

    @impl true
    def handle_call(action, _from, cards) do
        case action do
            {:chupai, num_of_cards} ->
                case chupai(cards,num_of_cards) do
                    {:error, msg} ->
                        {:reply,{:error, msg},cards}
                    {:ok, out_cards, left_cards} ->
                        {:reply, {:ok, out_cards}, left_cards}
                end
            {:yingpai, new_cards} ->
                {:reply,{:ok,:queue.join(cards, new_cards)},:queue.join(cards, new_cards)}
            {:cards} ->
                {:reply,{:ok,cards},cards}
            msg ->
                    IO.puts "unknow message #{msg}"
        end
    end
end