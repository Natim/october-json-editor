module Data.Msg exposing (Msg(..))

import File exposing (File)


type Msg
    = UpdateIBAN String String
    | UpdateBIC String String
    | DownloadJSON
    | LoadJSON
    | JSONFileLoaded File
    | JSONLoaded String
