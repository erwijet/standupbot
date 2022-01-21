module Slack exposing (msgSuccessDecoder, msgErrorDecoder, sendSlackMsg)

import Shared exposing (..)
import Http
import Json.Decode as JD
import Http exposing (Error, request, send)
import String exposing (replace)

--

msgSuccessDecoder : JD.Decoder String
msgSuccessDecoder = JD.field "output" JD.string

msgErrorDecoder : JD.Decoder String
msgErrorDecoder = JD.field "error" JD.string

--

sendSlackMsg : Model -> Cmd Msg
sendSlackMsg model =
    let
        req = Http.request
            { method = "POST"
            , headers = [ ]
            , url = model.slackHook
            , body = Http.stringBody "application/x-www-form-urlencoded" (
                replace "##cur_work##" model.curWork (
                    replace "##past_work##" model.pastWork (
                        replace "##user##" model.user model.template ) ) )
            , expect = Http.expectString
            , withCredentials = False
            , timeout = Nothing
            }
    in
        Http.send SlackApiDone req