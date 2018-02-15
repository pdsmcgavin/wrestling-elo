defmodule WweloApi.StatsTest do
  use WweloApi.DataCase

  alias WweloApi.Stats

  describe "wrestlers" do
    alias WweloApi.Stats.Wrestler

    @valid_attrs %{
      career_end_date: ~D[2010-04-17],
      career_start_date: ~D[2010-04-17],
      current_elo: 42,
      draw: 42,
      gender: "some gender",
      height: 42,
      losses: 42,
      maximum_elo: 42,
      minimum_elo: 42,
      name: "some name",
      weight: 42,
      wins: 42
    }
    @update_attrs %{
      career_end_date: ~D[2011-05-18],
      career_start_date: ~D[2011-05-18],
      current_elo: 43,
      draw: 43,
      gender: "some updated gender",
      height: 43,
      losses: 43,
      maximum_elo: 43,
      minimum_elo: 43,
      name: "some updated name",
      weight: 43,
      wins: 43
    }
    @invalid_attrs %{
      career_end_date: nil,
      career_start_date: nil,
      current_elo: nil,
      draw: nil,
      gender: nil,
      height: nil,
      losses: nil,
      maximum_elo: nil,
      minimum_elo: nil,
      name: nil,
      weight: nil,
      wins: nil
    }

    def wrestler_fixture(attrs \\ %{}) do
      {:ok, wrestler} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stats.create_wrestler()

      wrestler
    end

    test "list_wrestlers/0 returns all wrestlers" do
      wrestler = wrestler_fixture()
      assert Stats.list_wrestlers() == [wrestler]
    end

    test "get_wrestler!/1 returns the wrestler with given id" do
      wrestler = wrestler_fixture()
      assert Stats.get_wrestler!(wrestler.id) == wrestler
    end

    test "create_wrestler/1 with valid data creates a wrestler" do
      assert {:ok, %Wrestler{} = wrestler} = Stats.create_wrestler(@valid_attrs)
      assert wrestler.career_end_date == ~D[2010-04-17]
      assert wrestler.career_start_date == ~D[2010-04-17]
      assert wrestler.current_elo == 42
      assert wrestler.draw == 42
      assert wrestler.gender == "some gender"
      assert wrestler.height == 42
      assert wrestler.losses == 42
      assert wrestler.maximum_elo == 42
      assert wrestler.minimum_elo == 42
      assert wrestler.name == "some name"
      assert wrestler.weight == 42
      assert wrestler.wins == 42
    end

    test "create_wrestler/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_wrestler(@invalid_attrs)
    end

    test "update_wrestler/2 with valid data updates the wrestler" do
      wrestler = wrestler_fixture()
      assert {:ok, wrestler} = Stats.update_wrestler(wrestler, @update_attrs)
      assert %Wrestler{} = wrestler
      assert wrestler.career_end_date == ~D[2011-05-18]
      assert wrestler.career_start_date == ~D[2011-05-18]
      assert wrestler.current_elo == 43
      assert wrestler.draw == 43
      assert wrestler.gender == "some updated gender"
      assert wrestler.height == 43
      assert wrestler.losses == 43
      assert wrestler.maximum_elo == 43
      assert wrestler.minimum_elo == 43
      assert wrestler.name == "some updated name"
      assert wrestler.weight == 43
      assert wrestler.wins == 43
    end

    test "update_wrestler/2 with invalid data returns error changeset" do
      wrestler = wrestler_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Stats.update_wrestler(wrestler, @invalid_attrs)

      assert wrestler == Stats.get_wrestler!(wrestler.id)
    end

    test "delete_wrestler/1 deletes the wrestler" do
      wrestler = wrestler_fixture()
      assert {:ok, %Wrestler{}} = Stats.delete_wrestler(wrestler)

      assert_raise Ecto.NoResultsError, fn ->
        Stats.get_wrestler!(wrestler.id)
      end
    end

    test "change_wrestler/1 returns a wrestler changeset" do
      wrestler = wrestler_fixture()
      assert %Ecto.Changeset{} = Stats.change_wrestler(wrestler)
    end
  end

  describe "aliases" do
    alias WweloApi.Stats.Alias

    @valid_attrs %{name: "some name", wrestler_id: 42}
    @update_attrs %{name: "some updated name", wrestler_id: 43}
    @invalid_attrs %{name: nil, wrestler_id: nil}

    def alias_fixture(attrs \\ %{}) do
      {:ok, alias} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stats.create_alias()

      alias
    end

    test "list_aliases/0 returns all aliases" do
      alias = alias_fixture()
      assert Stats.list_aliases() == [alias]
    end

    test "get_alias!/1 returns the alias with given id" do
      alias = alias_fixture()
      assert Stats.get_alias!(alias.id) == alias
    end

    test "create_alias/1 with valid data creates a alias" do
      assert {:ok, %Alias{} = alias} = Stats.create_alias(@valid_attrs)
      assert alias.name == "some name"
      assert alias.wrestler_id == 42
    end

    test "create_alias/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_alias(@invalid_attrs)
    end

    test "update_alias/2 with valid data updates the alias" do
      alias = alias_fixture()
      assert {:ok, alias} = Stats.update_alias(alias, @update_attrs)
      assert %Alias{} = alias
      assert alias.name == "some updated name"
      assert alias.wrestler_id == 43
    end

    test "update_alias/2 with invalid data returns error changeset" do
      alias = alias_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Stats.update_alias(alias, @invalid_attrs)

      assert alias == Stats.get_alias!(alias.id)
    end

    test "delete_alias/1 deletes the alias" do
      alias = alias_fixture()
      assert {:ok, %Alias{}} = Stats.delete_alias(alias)
      assert_raise Ecto.NoResultsError, fn -> Stats.get_alias!(alias.id) end
    end

    test "change_alias/1 returns a alias changeset" do
      alias = alias_fixture()
      assert %Ecto.Changeset{} = Stats.change_alias(alias)
    end
  end

  describe "events" do
    alias WweloApi.Stats.Event

    @valid_attrs %{
      arena: "some arena",
      brand: "some brand",
      date: ~D[2010-04-17],
      event_type: "some event_type",
      location: "some location",
      name: "some name",
      promotion: "some promotion"
    }
    @update_attrs %{
      arena: "some updated arena",
      brand: "some updated brand",
      date: ~D[2011-05-18],
      event_type: "some updated event_type",
      location: "some updated location",
      name: "some updated name",
      promotion: "some updated promotion"
    }
    @invalid_attrs %{
      arena: nil,
      brand: nil,
      date: nil,
      event_type: nil,
      location: nil,
      name: nil,
      promotion: nil
    }

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stats.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Stats.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Stats.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Stats.create_event(@valid_attrs)
      assert event.arena == "some arena"
      assert event.brand == "some brand"
      assert event.date == ~D[2010-04-17]
      assert event.event_type == "some event_type"
      assert event.location == "some location"
      assert event.name == "some name"
      assert event.promotion == "some promotion"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Stats.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.arena == "some updated arena"
      assert event.brand == "some updated brand"
      assert event.date == ~D[2011-05-18]
      assert event.event_type == "some updated event_type"
      assert event.location == "some updated location"
      assert event.name == "some updated name"
      assert event.promotion == "some updated promotion"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Stats.update_event(event, @invalid_attrs)

      assert event == Stats.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Stats.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Stats.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Stats.change_event(event)
    end
  end

  describe "matches" do
    alias WweloApi.Stats.Match

    @valid_attrs %{
      card_position: 42,
      event_id: 42,
      stipulation: "some stipulation"
    }
    @update_attrs %{
      card_position: 43,
      event_id: 43,
      stipulation: "some updated stipulation"
    }
    @invalid_attrs %{card_position: nil, event_id: nil, stipulation: nil}

    def match_fixture(attrs \\ %{}) do
      {:ok, match} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stats.create_match()

      match
    end

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Stats.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Stats.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      assert {:ok, %Match{} = match} = Stats.create_match(@valid_attrs)
      assert match.card_position == 42
      assert match.event_id == 42
      assert match.stipulation == "some stipulation"
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      assert {:ok, match} = Stats.update_match(match, @update_attrs)
      assert %Match{} = match
      assert match.card_position == 43
      assert match.event_id == 43
      assert match.stipulation == "some updated stipulation"
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Stats.update_match(match, @invalid_attrs)

      assert match == Stats.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Stats.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Stats.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Stats.change_match(match)
    end
  end

  describe "participants" do
    alias WweloApi.Stats.Participant

    @valid_attrs %{
      elo_after: 42,
      match_id: 42,
      match_team: 42,
      outcome: "some outcome",
      wrestler_id: 42
    }
    @update_attrs %{
      elo_after: 43,
      match_id: 43,
      match_team: 43,
      outcome: "some updated outcome",
      wrestler_id: 43
    }
    @invalid_attrs %{
      elo_after: nil,
      match_id: nil,
      match_team: nil,
      outcome: nil,
      wrestler_id: nil
    }

    def participant_fixture(attrs \\ %{}) do
      {:ok, participant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stats.create_participant()

      participant
    end

    test "list_participants/0 returns all participants" do
      participant = participant_fixture()
      assert Stats.list_participants() == [participant]
    end

    test "get_participant!/1 returns the participant with given id" do
      participant = participant_fixture()
      assert Stats.get_participant!(participant.id) == participant
    end

    test "create_participant/1 with valid data creates a participant" do
      assert {:ok, %Participant{} = participant} =
               Stats.create_participant(@valid_attrs)

      assert participant.elo_after == 42
      assert participant.match_id == 42
      assert participant.match_team == 42
      assert participant.outcome == "some outcome"
      assert participant.wrestler_id == 42
    end

    test "create_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Stats.create_participant(@invalid_attrs)
    end

    test "update_participant/2 with valid data updates the participant" do
      participant = participant_fixture()

      assert {:ok, participant} =
               Stats.update_participant(participant, @update_attrs)

      assert %Participant{} = participant
      assert participant.elo_after == 43
      assert participant.match_id == 43
      assert participant.match_team == 43
      assert participant.outcome == "some updated outcome"
      assert participant.wrestler_id == 43
    end

    test "update_participant/2 with invalid data returns error changeset" do
      participant = participant_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Stats.update_participant(participant, @invalid_attrs)

      assert participant == Stats.get_participant!(participant.id)
    end

    test "delete_participant/1 deletes the participant" do
      participant = participant_fixture()
      assert {:ok, %Participant{}} = Stats.delete_participant(participant)

      assert_raise Ecto.NoResultsError, fn ->
        Stats.get_participant!(participant.id)
      end
    end

    test "change_participant/1 returns a participant changeset" do
      participant = participant_fixture()
      assert %Ecto.Changeset{} = Stats.change_participant(participant)
    end
  end
end
