module Main exposing (..)

import Array exposing (..)
import String exposing (split)
import Browser
import List
import Debug
import Modal exposing (modal)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as JD
import Shared exposing (..)
import Slack


fromJust : Maybe String -> String
fromJust x =
    case x of
        Just y ->
            y

        Nothing ->
            ""

main : Program (Array String) Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


init : Array String -> ( Model, Cmd Msg )
init flags =
    ( Model (fromJust (Array.get 0 flags)) (fromJust (Array.get 1 flags)) (fromJust (Array.get 2 flags)) (fromJust (Array.get 3 flags)) (fromJust (Array.get 4 flags)) "" "" False Nothing
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CloseModal ->
            ( { model | slackPosted = False, error = Nothing }, Cmd.none )

        SlackApiDone (Ok response) ->
            ( { model | slackPosted = True, error = Nothing }, Cmd.none )

        SlackApiDone (Err err) ->
            let
                errMsg =
                    case err of
                        Http.Timeout ->
                            "Request timeout"

                        Http.NetworkError ->
                            "Network error"

                        Http.BadStatus response ->
                            case JD.decodeString Slack.msgErrorDecoder response.body of
                                Ok errStr ->
                                    errStr

                                Err _ ->
                                    response.status.message

                        Http.BadUrl badUrlMsg ->
                            "Bad url: " ++ badUrlMsg

                        Http.BadPayload badPayloadMsg _ ->
                            "Bad payload: " ++ badPayloadMsg
            in
            ( { model | slackPosted = False, error = Just errMsg }, Cmd.none )

        UpdatePastWorkStr str ->
            ( { model | pastWork = str }, Cmd.none )

        UpdateCurWorkStr str ->
            ( { model | curWork = str }, Cmd.none )

        PostStandup ->
            ( model, Slack.sendSlackMsg model )



-- VIEW


view : Model -> Html Msg
view model =
    let
        outDiv =
            case model.error of
                Nothing ->
                    if model.slackPosted then modal "is-success" "Success!" "Standup posted to Slack. Check the Standup channel and it should be there!" else div [] []
                Just err ->
                    div []
                        [ label [ for "errorUpcase" ] [ text "Error" ]
                        , input [ type_ "text", id "errorUpcase", readonly True, value err ] []
                        ]
    in
    div []
        [ section [ class "hero is-link is-medium" ]
            [ div [ class "hero-body" ]
                [ p [ class "title" ] [text ( "Hello, " ++ ( fromJust ( ( split " " model.g_userName ) |> List.head ) ) ) ] 
                , p [ class "subtitle" ] [ text "SWEN 261-01 Team 3 Standup Submission Form" ] 
                ]  
            ]
        , div [ class "box", style "margin" "1%", style "padding" "1%" ]
            [ div [ class "field" ] [ label [ class "label" ] [ text "Past Work" ], div [ class "control" ] [ textarea [ class "textarea", placeholder "Watching Netflix...", onInput UpdatePastWorkStr ] [] ] ]
            , div [ class "field" ] [ label [ class "label" ] [ text "Planned Work" ], div [ class "control" ] [ textarea [ class "textarea", placeholder "Eat potato chips...", onInput UpdateCurWorkStr ] [] ] ]
            , button [ class "button is-success is-outlined", onClick PostStandup ] 
                [ span [ class "icon is-small" ] [ i [ class "fab fa-slack" ] [] ]
                , span [] [ text "Post in Slack" ] 
                ]
            ]
        , outDiv
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
