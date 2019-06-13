defmodule Player do
    #drop one card
    def chupai(cards_in_hand,num \\ 1,out_cards \\ :queue.new())
    def chupai([],_,_), do: {:error, "There are zero cards left"}
    def chupai(_,0,out_cards), do: {:ok, out_cards}

    def chupai(cards_in_hand,num,out_cards) do
        if :queue.len(cards_in_hand) < num do
            {:error, "There are only #{:queue.len(cards_in_hand)} cards in hand"}
        else
            {{:value, card}, que} = :queue.out(cards_in_hand)      
            chupai(que,num-1,que)     
        end
    end


    def play(cards) do
        receive do
            {:fapai, cards} ->
                play(:queue.from_list(cards))
            {:chupai, num_of_cards, to_who} ->
                send(to_who, chupai(cards,num_of_cards))
        end
    end
end