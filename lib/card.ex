defmodule Cards do
    use GenServer
    #TODO: daxiao wang
    @heitao ["heitao1","heitao2","heitao3","heitao4","heitao5","heitao6","heitao7","heitao8","heitao9","heitao10","heitao11","heitao12","heitao13"]
    @hongtao ["hongtao1","hongtao2","hongtao3","hongtao4","hongtao5","hongtao6","hongtao7","hongtao8","hongtao9","hongtao10","hongtao11","hongtao12","hongtao13"]
    @fangkuai ["fangkuai1","fangkuai2","fangkuai3","fangkuai4","fangkuai5","fangkuai6","fangkuai7","fangkuai8","fangkuai9","fangkuai10","fangkuai11","fangkuai12","fangkuai13"]
    @meihua ["meihua1","meihua2","meihua3","meihua4","meihua5","meihua6","meihua7","meihua8","meihua9","meihua10","meihua11","meihua12","meihua13"]
    @cards Enum.shuffle(@heitao ++ @hongtao ++ @fangkuai ++ @meihua)

    @impl true
    def init(cards) do
        cards = cards || @cards
        {:ok, cards}
    end

    @impl true
    def handle_call(action, from, cards) do
        case action do
            :fapai ->
                {card, left_cards} = fapai(cards)
                {:reply, card, left_cards}
            :left_cards ->
                {:reply, cards, cards}
            msg ->
                IO.puts "unknow message #{msg}"

        end
    end

    @impl true
    def handle_cast(:xipai, cards) do
        {:noreply, Enum.shuffle(cards)}
    end

    def get_cards, do: @cards

    def fapai(cards) do
        card = Enum.take_random(cards,1)
        left_cards = Enum.drop_while(cards, fn x -> x == card end)
        {card, left_cards}
    end

    def fapai([]) do
        {[],[]}
    end


end