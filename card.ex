defmodule Cards do
    #TODO: daxiao wang
    @heitao ["heitaoA","heitao2","heitao3","heitao4","heitao5","heitao6","heitao7","heitao8","heitao9","heitao10","heitaoJ","heitaoQ","heitaoK"]
    @hongtao ["hongtaoA","hongtao2","hongtao3","hongtao4","hongtao5","hongtao6","hongtao7","hongtao8","hongtao9","hongtao10","hongtaoJ","hongtaoQ","hongtaoK"]
    @fangkuai ["fangkuaiA","fangkuai2","fangkuai3","fangkuai4","fangkuai5","fangkuai6","fangkuai7","fangkuai8","fangkuai9","fangkuai10","fangkuaiJ","fangkuaiQ","fangkuaiK"]
    @meihua ["meihuaA","meihua2","meihua3","meihua4","meihua5","meihua6","meihua7","meihua8","meihua9","meihua10","meihuaJ","meihuaQ","meihuaK"]
    @cards Enum.shuffle(@heitao ++ @hongtao ++ @fangkuai ++ @meihua)

    def get_cards, do: @cards

    def fapai(cards) do
        card = Enum.take_random(cards,1)
        left_cards = Enum.drop_while(cards, fn x -> x == card end)
        {card, left_cards}
    end

    def fapai([]) do
        {nil,[]}
    end

    def start(cards \\ @cards) do
        receive do
            :xipai -> 
                cards
                |> Enum.shuffle
                |>start()
            {:fapai, to_player} -> 
                {card, left_cards} = fapai(cards)
                case card do
                    nil ->
                        send(to_player, {:error, "There is no cards left"})
                    _ ->
                        send(to_player, {:ok, card})
                end
                
                start(left_cards)
            {:left_cards, to_player} ->
                send(to_player,cards)
                start(cards)
            _ -> 
                IO.puts "unknow message"
                start(cards)
        end
    end


end