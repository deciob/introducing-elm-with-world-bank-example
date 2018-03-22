module Main exposing (main)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Random


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias IndicatorDatum =
    { countryId : String
    , countryName : String
    , year : String
    , value : Maybe Float
    }


type alias Model =
    { currentIdx : Maybe Int
    , currentIndicatorName : String
    , data : List IndicatorDatum
    }


indicatorIds : Dict Int String
indicatorIds =
    Dict.fromList [ ( 0, "EG.FEC.RNEW.ZS" ), ( 1, "EG.ELC.PETR.ZS" ), ( 2, "EG.ELC.ACCS.RU.ZS" ) ]


init : ( Model, Cmd Msg )
init =
    ( { currentIdx = Nothing
      , currentIndicatorName = ""
      , data = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp (Result Http.Error (List IndicatorDatum))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [] [ text "TODO" ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getData : String -> Cmd Msg
getData indicator =
    let
        url =
            "https://api.worldbank.org/v2/countries/all/indicators/"
                ++ indicator
                ++ "?date=2002:2002&format=json&per_page=500"
    in
    Http.send NoOp (Http.get url decodeResponse)


decodeIndicator : Decode.Decoder IndicatorDatum
decodeIndicator =
    Decode.map4 IndicatorDatum
        (Decode.at [ "country", "id" ] Decode.string)
        (Decode.at [ "country", "value" ] Decode.string)
        (Decode.field "date" Decode.string)
        (Decode.field "value" <| Decode.maybe Decode.float)


decodeResponse : Decode.Decoder (List IndicatorDatum)
decodeResponse =
    Decode.index 1 (Decode.list decodeIndicator)
