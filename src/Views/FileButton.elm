module Views.FileButton exposing (exportButton, loadButton)

import Data.BankTransaction as BankTransaction exposing (BankTransaction)
import Data.Model exposing (Model)
import Data.Msg exposing (Msg(..))
import Html exposing (Html, button, text)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


loadButton : Html Msg
loadButton =
    button
        [ type_ "button"
        , class "btn btn-success"
        , onClick LoadJSON
        ]
        [ text "Load JSON" ]


exportButton : Model -> Html Msg
exportButton model =
    let
        incomplete_transactions =
            model.allTransactions
                |> List.filter (\t -> t.updated_iban == "" || t.updated_bic == "")

        nb_transactions =
            List.length incomplete_transactions
    in
    if nb_transactions == 0 then
        button
            [ type_ "button"
            , class "btn btn-success"
            , onClick DownloadJSON
            ]
            [ text "Export JSON" ]

    else
        text ""
