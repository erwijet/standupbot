module Slack exposing (sendSlackMsg)

import Http exposing (expectString, request, send)
import Shared exposing (..)
import String exposing (replace)

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
