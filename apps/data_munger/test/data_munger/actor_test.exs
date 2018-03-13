defmodule DataMunger.ActorTest do
  use ExUnit.Case, async: true
  alias DataMunger.Actor
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(DataMunger.Repo)
  end

  test "can convert a name_basic record to an actor record" do
    ["Humphrey Bogart", "Natalie Portman"]
    |> Enum.each(fn(who) -> 
      [name] = from(n in DataMunger.NameBasic,
                  where: ilike(n.primary_name, ^who),
                  select: n) 
               |> DataMunger.ImdbRepo.all() 
       change = Actor.changeset(%Actor{}, name)

       {:ok, actor} = DataMunger.Repo.insert(change)
       assert actor.name == name.primary_name
       assert actor.nconst == name.nconst
       assert actor.birth_year == name.birth_year
       assert actor.death_year == name.death_year
    end)
  end
end
