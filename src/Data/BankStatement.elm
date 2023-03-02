module Data.BankStatement exposing
    ( BankStatement
    , decode
    , encode
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode


type alias BankStatement =
    { startDate : String
    , endDate : String
    , iban : String
    , bic : String
    , statementId : Int
    , pageCount : Int
    , startBalance : Float
    , endBalance : Float
    , totalCreditAmount : Float
    , totalDebitAmount : Float
    , movements : String
    }


decode : Decoder BankStatement
decode =
    Decode.succeed BankStatement
        |> required "startDate" Decode.string
        |> required "endDate" Decode.string
        |> required "bic" Decode.string
        |> required "iban" Decode.string
        |> required "statementId" Decode.int
        |> required "pageCount" Decode.int
        |> required "startBalance" Decode.float
        |> required "endBalance" Decode.float
        |> required "totalCreditAmount" Decode.float
        |> required "totalDebitAmount" Decode.float
        |> required "movements" Decode.string


encode : BankStatement -> Encode.Value
encode statement =
    Encode.object
        [ ( "startDate", Encode.string statement.startDate )
        , ( "endDate", Encode.string statement.endDate )
        , ( "bic", Encode.string statement.bic )
        , ( "iban", Encode.string statement.iban )
        , ( "statementId", Encode.int statement.statementId )
        , ( "pageCount", Encode.int statement.pageCount )
        , ( "startBalance", Encode.float statement.startBalance )
        , ( "endBalance", Encode.float statement.endBalance )
        , ( "totalCreditAmount", Encode.float statement.totalCreditAmount )
        , ( "totalDebitAmount", Encode.float statement.totalDebitAmount )
        , ( "movements", Encode.string statement.movements )
        ]
