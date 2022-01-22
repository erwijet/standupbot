module Slack exposing (msgErrorDecoder, msgSuccessDecoder, sendSlackMsg)

import Http exposing (expectString, request, send)
import Json.Decode as JD
import Shared exposing (..)
import String exposing (replace)



--


msgSuccessDecoder : JD.Decoder String
msgSuccessDecoder =
    JD.field "output" JD.string


msgErrorDecoder : JD.Decoder String
msgErrorDecoder =
    JD.field "error" JD.string



--


sendSlackMsg : Model -> Cmd Msg
sendSlackMsg model =
    let
        req =
            request
                { method = "POST"
                , headers = []
                , url = model.slackHook
                , body =
                    Http.stringBody "application/x-www-form-urlencoded"
                        (replace "##cur_work##"
                            model.curWork
                            (replace "##past_work##"
                                model.pastWork
                                (replace "##user##"
                                    model.g_userName
                                    (replace "##date##" model.date model.template)
                                )
                            )
                        )
                , expect = expectString
                , withCredentials = False
                , timeout = Nothing
                }
    in
    send SlackApiDone req
