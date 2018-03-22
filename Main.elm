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
    , Random.generate NewIndex (Random.int 0 2)
    )



-- UPDATE


type Msg
    = RequestData
    | NewData (Result Http.Error (List IndicatorDatum))
    | NewIndex Int
    | GenerateRandomIdx


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestData ->
            ( model, Random.generate NewIndex (Random.int 0 2) )

        NewData (Ok data) ->
            ( { model | data = data }, Cmd.none )

        NewData (Err error) ->
            let
                _ =
                    Debug.log "error" error
            in
            ( model, Cmd.none )

        GenerateRandomIdx ->
            ( model, Random.generate NewIndex (Random.int 0 2) )

        NewIndex index ->
            let
                indicator =
                    indicatorIds |> Dict.get index |> Maybe.withDefault ""
            in
            ( { model | currentIdx = Just index }, getData indicator )



-- VIEW


view : Model -> Html Msg
view model =
    let
        stringValue : Maybe Float -> String
        stringValue value =
            case value of
                Just value ->
                    toString value

                Nothing ->
                    "-"

        currentIdx =
            Maybe.withDefault 0 model.currentIdx
    in
    div []
        [ h2 [] [ text (indicatorIds |> Dict.get currentIdx |> Maybe.withDefault "") ]
        , button [ onClick GenerateRandomIdx ] [ text "Request Data From a random indicator!" ]
        , div [ class "data" ]
            [ ul [] <|
                List.map
                    (\d ->
                        li [] [ text <| d.countryName ++ ": " ++ stringValue d.value ]
                    )
                    model.data
            ]
        ]



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
    Http.send NewData (Http.get url decodeResponse)


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
