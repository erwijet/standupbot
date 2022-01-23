module Modal exposing (modal)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Shared exposing (..)


modal : String -> String -> Html Msg
modal title content =
    div [ class "modal is-active" ]
        [ div [ class "modal-background", onClick CloseModal ] []
        , div [ class "modal-card" ]
            [ header [ class "modal-card-head" ]
                [ p [ class "modal-card-title" ] [ text title ]
                , button [ class "delete", onClick CloseModal ] []
                ]
            , section [ class "modal-card-body" ] [ text content ]
            , footer [ class "modal-card-foot" ] []
            ]
        ]
