# Meow

This code base follows the examples from the book "Building tables views with Phoenix Liveview but with the later version of Pheonix 1.7.2"

Steps:
1. mix phx.new meow
2. cd meow
3. mix ecto.create
4. mix phx.gen.live Meerkats Meerkat meerkats name:string
5. copy paste routes
6. mix ecto.migrate
7. follow tutorial in book
    - work on lib/meow_web/live/meerkat_live/index.ex
    - work on lib/meow_web/live/meerkat_live/index.html.heex
    - work on lib/meow/meerkats/meerkats/ex
    - create lib/meow_web/live/meerkat_live/sorting_component.ex
    - create lib/meow_web/forms/sorting_form.ex