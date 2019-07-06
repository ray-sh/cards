defmodule TableSup do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      Supervisor.child_spec({Table, :table1}, id: :table1),
      Supervisor.child_spec({Table, :table2}, id: :table2),
      Supervisor.child_spec({Table, :table3}, id: :table3)
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
