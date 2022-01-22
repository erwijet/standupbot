module Modal exposing (modal)

import Shared exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style)

modal : String -> String -> String -> Html Msg
modal colorClass title content =
    div [ class "modal is-active", class colorClass ]
        [ div [ class "modal-background", onClick CloseModal ] []
        , div [ class "modal-card" ] 
            [ header [ class "modal-card-head" ]
                [ p [ class "modal-card-title" ] [ text title ]
                , button [ class "delete", onClick CloseModal ] [ ]
                ]
            , section [ class "modal-card-body" ] [ text content ]
            , footer [ class "modal-card-footer" ] []
            ]
        ]
    