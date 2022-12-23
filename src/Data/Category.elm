module Data.Category exposing
    ( Category
    , decode
    , encode
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional)
import Json.Encode as Encode


type alias Category =
    { subtype : Maybe String
    , type_ : Maybe String
    }


decode : Decoder Category
decode =
    Decode.succeed Category
        |> optional "subtype" (Decode.maybe Decode.string) Nothing
        |> optional "type" (Decode.maybe Decode.string) Nothing


nullableString : Maybe String -> Encode.Value
nullableString maybe_string =
    case maybe_string of
        Nothing ->
            Encode.null

        Just string ->
            Encode.string string


encode : Category -> Encode.Value
encode category =
    Encode.object
        [ ( "subtype", nullableString category.subtype )
        , ( "type", nullableString category.type_ )
        ]
