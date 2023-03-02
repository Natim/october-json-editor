module Data.Model exposing (Model)

import Data.BankStatement exposing (BankStatement)
import Data.BankTransaction exposing (BankTransaction)


type alias Model =
    { allTransactions : List BankTransaction
    , summary : List BankStatement
    }
