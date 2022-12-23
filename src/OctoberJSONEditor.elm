module OctoberJSONEditor exposing (main)

import Browser
import Data.BankTransaction as BankTransaction exposing (BankTransaction)
import Data.Model exposing (Model)
import Data.Msg exposing (Msg(..))
import File
import File.Download as Download
import File.Select as Select
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode exposing (decodeString)
import Json.Encode as Encode
import Task
import Views.BankTransaction exposing (showTransaction)
import Views.FileButton exposing (exportButton, loadButton)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


init : () -> ( Model, Cmd Msg )
init flags =
    ( { allTransactions = [] }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadJSON ->
            let
                select =
                    Select.file [ "application/json" ] JSONFileLoaded
            in
            ( model, select )

        JSONFileLoaded file ->
            ( model, Task.perform JSONLoaded (File.toString file) )

        JSONLoaded jsonString ->
            let
                decoder =
                    BankTransaction.decode
                        |> Decode.list
                        |> Decode.at [ "allTransactions" ]

                allTransactions =
                    decodeString decoder jsonString
                        |> Debug.log "Error"
                        |> Result.withDefault []
            in
            ( { model | allTransactions = allTransactions }, Cmd.none )

        UpdateIBAN bic iban ->
            let
                updatedTransactions =
                    model.allTransactions
                        |> List.map
                            (\t ->
                                if t.bic == bic && (t.iban == "") then
                                    { t | updated_iban = iban }

                                else
                                    t
                            )
            in
            ( { model | allTransactions = updatedTransactions }, Cmd.none )

        UpdateBIC iban bic ->
            let
                updatedTransactions =
                    model.allTransactions
                        |> List.map
                            (\t ->
                                if t.iban == iban && (t.bic == "") then
                                    { t | updated_bic = bic }

                                else
                                    t
                            )
            in
            ( { model | allTransactions = updatedTransactions }, Cmd.none )

        DownloadJSON ->
            let
                json =
                    Encode.object
                        [ ( "allTransactions"
                          , model.allTransactions
                                |> Encode.list BankTransaction.encode
                          )
                        ]
                        |> Encode.encode 4
                        |> Download.string "october-fixed.json" "application/json"
            in
            ( model, json )


view : Model -> Html Msg
view model =
    if List.length model.allTransactions == 0 then
        loadButton

    else
        let
            incomplete_transactions =
                model.allTransactions
                    |> List.filter (\t -> t.iban == "" || t.bic == "")

            nb_transactions =
                List.length incomplete_transactions
        in
        if nb_transactions == 0 then
            h3 [] [ text "The file is complete, all transactions have a IBAN and BIC number associated with them." ]

        else
            div []
                [ h3 [] [ text <| String.fromInt nb_transactions ++ " transactions are missing important informations: IBAN or BIC. Please fix them bellow:" ]
                , exportButton model
                , List.concat
                    [ [ thead []
                            [ tr []
                                [ th [ attribute "scope" "col" ] [ text "Date" ]
                                , th [ attribute "scope" "col" ] [ text "IBAN" ]
                                , th [ attribute "scope" "col" ] [ text "BIC" ]
                                , th [ attribute "scope" "col" ] [ text "Amount" ]
                                ]
                            ]
                      ]
                    , [ incomplete_transactions
                            |> List.map showTransaction
                            |> tbody []
                      ]
                    ]
                    |> table [ class "table table-striped" ]
                ]
