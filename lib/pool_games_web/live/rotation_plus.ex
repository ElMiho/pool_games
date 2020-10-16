defmodule PoolGamesWeb.RotationPlus do
  use PoolGamesWeb, :live_view
  alias Phoenix.LiveView.Socket

  def mount(_params, _session, socket) do

    players = []

    saved_players = File.read!("players.txt")
    saved_players = String.split(saved_players, ";")
    saved_players = Enum.filter(saved_players, fn(x) -> x != "" end)

    socket = assign(socket,
      players: players,
      saved_players: saved_players)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.1/css/bulma.min.css">

    <h1 class="title"> Rotation+ scoring system </h1>

    <form phx-submit="score">

    <p> Select player (points): </p>
    <select id="player" name="player">
      <%= for player <- @players do %>
        <option <%= player.name %> > <%= player.name %> </option>
      <%= end %>
    </select>

    <p> Add or subtract </p>
    <select id="points" name="points">
      <option selected > Add </option>
      <option > Subtract </option>
    </select>

    <table>
      <tr>
        <%= for num <- 1..15 do %>
          <td>
          <table>
            <%= num %>
            <br>
            <input type="checkbox" id="<%= num %>" name="<%= num %>">
          </table>
          </td>
        <%= end %>
      </tr>
    </table>

    <button class="button is-primary is-large" type="submit"> Score </button>
    </form>

    <table>
    <tr>
      <%= for player <- @players do %>
        <td>
        <p> Name: <%= inspect player.name %> </p>
        <p> Score list: <%= inspect player.score %> </p>
        <p> Score: <%= inspect sum_list(player.score) %> </p>
        </td>
      <% end %>
    </tr>
    </table>

    <form phx-submit="add_players">
    <p> Saved players </p>
    <select id="saved" name="saved">
      <%= for player <- @saved_players do %>
        <option> <%= player %> </option>
      <% end %>
    </select>
    <br>
    <button class="button is-primary is-large" type="submit"> Add players to game </button>
    </form>

    <form phx-submit="add_players_database">
    <input class="input is-medium" id="players_input" name="players_input" placeholder="Players seperated by ;">
    <button class="button is-primary is-large" type="submit"> Add players to database </button>
    </form>

    <form phx-submit="reset">
    <button class="button is-primary is-large" type="submit"> Reset </button>
    </form>

    """
  end

  def sum_list(list) do
    Enum.sum(list)
  end

  def get_player_from_name(name, players) do
    Enum.find(players, fn(player) -> player.name == name end)
  end

  def handle_event("score", args, %Socket{assigns: %{players: players}} = socket) do

    if args["points"] == "Add" do
      score_list = for num <- 1..15 do
        if args[Integer.to_string(num)] != nil do
          num
        else
          0
        end
      end

      score_list = Enum.filter(score_list, fn(x) -> x != 0 end)
      player = get_player_from_name(args["player"], players)
      player = Map.replace!(player, :score, player.score ++ score_list)

      {current_player, other_players} = Enum.split_with(players, fn(x) -> x.name == player.name end)


      socket = assign(socket,
        players: Enum.sort(other_players ++ [player]))

      {:noreply, socket}

    else
      remove_list = for num <- 1..15 do
        if args[Integer.to_string(num)] != nil do
          num
        else
          0
        end
      end

      player = get_player_from_name(args["player"], players)
      new_score_list = Enum.reduce(remove_list, player.score, fn(x, acc) -> List.delete(acc, x) end)
      saplayer = Map.replace!(player, :score, new_score_list)

      {current_player, other_players} = Enum.split_with(players, fn(x) -> x.name == player.name end)

      socket = assign(socket,
        players: Enum.sort(other_players ++ [player]))

      {:noreply, socket}

    end

  end

  def handle_event("add_players", args, %Socket{assigns: %{players: players}} = socket) do

    IO.puts("#{inspect args["saved"]}")
    player_name = args["saved"]
    player = %{name: player_name, score: []}

    socket = assign(socket,
      players: Enum.sort(players ++ [player]))

    {:noreply, socket}
  end

  def handle_event("add_players_database", args, %Socket{assigns: %{players: players}} = socket) do
    players_list = String.split(args["players_input"], ";")
    created_players = Enum.map(players_list, fn(player) -> %{name: player, score: []} end)

    :ok = Enum.each(players_list, fn(x) -> File.write("players.txt", "#{x};", [:append]) end)

    socket = assign(socket,
      saved_players: Enum.sort(players ++ created_players))

    {:noreply, socket}
  end

  def handle_event("reset", args, %Socket{assigns: %{players: players}} = socket) do

    socket = assign(socket,
      players: [])

    {:noreply, socket}
  end

end
