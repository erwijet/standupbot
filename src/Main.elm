module Main exposing (..)

import Html exposing (..)
import Http exposing (..)
import Array exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Json.Decode as JD
import Shared exposing (..)
import Array exposing (..)

import Debug
import Slack
import Browser

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

init : (Array String) -> (Model, Cmd Msg)
init flags =
    ( Model (fromJust (Array.get 0 flags)) (fromJust (Array.get 1 flags)) "" "" "" "" Nothing
    , Cmd.none
    )

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SlackApiDone (Ok response) ->
            ( { model | output = "Success!", error = Nothing }, Cmd.none )

        SlackApiDone (Err err) ->
            let
                errMsg = case err of
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
                ( { model | output = "", error = Just errMsg }, Cmd.none )

        UpdateUserStr str ->
            ( { model | user = str }, Cmd.none )

        UpdatePastWorkStr str ->
            ( { model | pastWork = str }, Cmd.none )

        UpdateCurWorkStr str ->
            ( { model | curWork = str }, Cmd.none )

        PostStandup ->
            ( model, Slack.sendSlackMsg model)

-- VIEW

view : Model -> Html Msg
view model =
    let
        outDiv = case model.error of
            Nothing ->
                div []
                    [ label [ for "outputUpcase" ] [ text "Output" ]
                    , input [ type_ "text", id "outputUpcase", readonly True, value "Success!"] []
                    ]

            Just err ->
                div []
                    [ label [ for "errorUpcase" ] [ text "Error" ]
                    , input [ type_ "text", id "errorUpcase", readonly True, value err ] []
                    ]
    in
        div []
            [ div []
                [ label [ for "pastWork" ] [ text "Past Work: " ]
                , input [ type_ "text", id "pastWork", onInput UpdatePastWorkStr ] []
                , label [ for "curWork"] [ text "Current/Future Work: " ]
                , input [ type_ "text", id "curWork", onInput UpdateCurWorkStr ] []
                , button [ onClick PostStandup ] [ text "Post in Slack" ]
                ]
            , outDiv
            ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- HELPERS
