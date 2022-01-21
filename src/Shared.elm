module Shared exposing (..)
import Http

{-
-- We define the application model in a seperate module
-- to allow both Main.elm, as well as Slack.elm to depend
-- upon a single source of truth, rather thana circular
-- dependency relationship / multiple definitions & sources of truth
-}

type alias Model =
    { template: String
    , slackHook: String
    , user: String
    , pastWork: String
    , curWork: String
    , output: String
    , error: Maybe String
    }

type Msg
    = SlackApiDone ( Result Http.Error String )
    | PostStandup
    | UpdateUserStr String
    | UpdatePastWorkStr String
    | UpdateCurWorkStr String
