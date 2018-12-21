# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ArWeekly.Repo.insert!(%ArWeekly.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ArWeekly.Subscribers.Subscriber

ArWeekly.Repo.delete_all(Subscriber)

ArWeekly.Repo.insert!(%Subscriber{
  email: "dominique+beta@donhubi.ch",
  is_active: true,
  is_beta: true
})

ArWeekly.Repo.insert!(%Subscriber{
  email: "dominique@donhubi.ch",
  is_active: true,
  is_beta: false
})
