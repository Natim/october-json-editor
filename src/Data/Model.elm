module Data.Model exposing (Model)

import Data.BankTransaction exposing (BankTransaction)


type alias Model =
    { allTransactions : List BankTransaction
    }
