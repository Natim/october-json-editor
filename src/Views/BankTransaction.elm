module Views.BankTransaction exposing
    ( fieldForBic
    , fieldForIban
    , showTransaction
    )

import Data.BankTransaction as BankTransaction exposing (BankTransaction)
import Data.Msg exposing (Msg(..))
import Html exposing (Html, input, td, text, tr)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


fieldForIban : BankTransaction -> Html Msg
fieldForIban bt =
    if bt.iban == "" then
        input [ type_ "text", value bt.updated_iban, class "form-control", onInput <| UpdateIBAN bt.bic ] []

    else
        text bt.iban


fieldForBic : BankTransaction -> Html Msg
fieldForBic bt =
    if bt.bic == "" then
        input [ type_ "text", value bt.updated_bic, class "form-control", onInput <| UpdateBIC bt.iban ] []

    else
        text bt.bic


showTransaction : BankTransaction -> Html Msg
showTransaction transaction =
    tr []
        [ td [ attribute "scope" "row" ] [ text transaction.date ]
        , td [] [ fieldForIban transaction ]
        , td [] [ fieldForBic transaction ]
        , td [] [ text <| BankTransaction.amount transaction ]
        ]
