module Utils exposing (euros)

import Round


euros : Float -> String
euros amount =
    (Round.round 2 amount ++ "€")
        |> String.replace "." ","
        |> String.replace ",00" ""
