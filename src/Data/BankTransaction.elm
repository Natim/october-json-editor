module Data.BankTransaction exposing
    ( BankTransaction
    , amount
    , decode
    , encode
    )

import Data.Category as Category exposing (Category)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Utils exposing (euros)


type alias BankTransaction =
    { iban : String
    , updated_iban : String
    , bic : String
    , updated_bic : String
    , date : String
    , counterparty : String
    , description : String
    , credit : Float
    , debit : Float
    , dailyStartBalance : Float
    , dailyEndBalance : Float
    , category : Category
    , providerCategory : Category
    , statementDate : String
    , statementId : Int
    , type_ : String
    }


amount : BankTransaction -> String
amount transaction =
    if transaction.credit /= 0 then
        euros transaction.credit

    else
        euros (transaction.debit * -1)


decodeIban : Decoder String
decodeIban =
    Decode.maybe Decode.string
        |> Decode.andThen (Maybe.withDefault "" >> Decode.succeed)


decode : Decoder BankTransaction
decode =
    Decode.succeed BankTransaction
        |> required "iban" decodeIban
        |> required "iban" decodeIban
        |> required "bic" Decode.string
        |> required "bic" Decode.string
        |> required "date" Decode.string
        |> required "counterparty" Decode.string
        |> required "description" Decode.string
        |> required "credit" Decode.float
        |> required "debit" Decode.float
        |> required "dailyStartBalance" Decode.float
        |> required "dailyEndBalance" Decode.float
        |> required "category" Category.decode
        |> required "providerCategory" Category.decode
        |> required "statementDate" Decode.string
        |> required "statementId" Decode.int
        |> required "type" Decode.string


encode : BankTransaction -> Encode.Value
encode transaction =
    Encode.object
        [ ( "iban", Encode.string transaction.updated_iban )
        , ( "bic", Encode.string transaction.updated_bic )
        , ( "date", Encode.string transaction.date )
        , ( "counterparty", Encode.string transaction.counterparty )
        , ( "description", Encode.string transaction.description )
        , ( "credit", Encode.float transaction.credit )
        , ( "debit", Encode.float transaction.debit )
        , ( "dailyStartBalance", Encode.float transaction.dailyStartBalance )
        , ( "dailyEndBalance", Encode.float transaction.dailyEndBalance )
        , ( "category", Category.encode transaction.category )
        , ( "providerCategory", Category.encode transaction.providerCategory )
        , ( "statementDate", Encode.string transaction.statementDate )
        , ( "statementId", Encode.int transaction.statementId )
        , ( "type", Encode.string transaction.type_ )
        ]
