defmodule Cards do
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, name: Player.Sup, strategy: :one_for_one}
    ]
    Supervisor.start_link(children, strategy: :one_for_one, name: Cards) |> IO.inspect
  end




    # TODO: daxiao wang
  @heitao ["a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12", "a13"]
  @hongtao ["b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "b9", "b10", "b11", "b12", "b13"]
  @meihua ["c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "c11", "c12", "c13"]
  @fangkuai ["d1", "d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9", "d10", "d11", "d12", "d13"]
  @cards Enum.shuffle(@heitao ++ @hongtao ++ @meihua ++ @fangkuai)



  def get_cards, do: @cards |> Enum.shuffle()

  def fapai([]), do: {[], []}

  def fapai(cards) do
    card = Enum.take_random(cards, 1)
    left_cards = Enum.drop_while(cards, fn x -> x == card end)
    {card, left_cards}
  end
end
