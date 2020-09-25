module Page.Installed exposing (Model, Msg, init, subscriptions, update, view)

import Context exposing (Context)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Lazy exposing (lazy2)
import Html.Events
import Json.Decode as Decode
import Models exposing (InstalledMod)
import String.Extra as String
import Styles exposing (colors, edges, sizes)



-- PORTS
-- MODEl


init : ( Model, Cmd Msg )
init =
    let
        initialModel =
            { inspectedCardId = Nothing
            }
    in
    ( initialModel, Cmd.none )


type alias Model =
    { inspectedCardId : Maybe String
    }



-- UPDATE


type Msg
    = InspectCard String


update : Context -> Msg -> Model -> ( Context, Model, Cmd Msg )
update context msg model =
    case msg of
        InspectCard id ->
            ( context, { model | inspectedCardId = Just id }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Context -> Model -> Element Msg
view context model =
    column
        [ width sizes.content
        , centerX
        , spacing 20
        , paddingEach { edges | top = 20 }
        ]
        [ viewHeading
        , lazy2 viewInstalledMods context.installedMods model.inspectedCardId
        ]


viewHeading : Element Msg
viewHeading =
    el [] (text "Heading")


viewInstalledMods : List InstalledMod -> Maybe String -> Element Msg
viewInstalledMods installedMods inspectedCardId =
    let
        getModHeight id =
            case inspectedCardId of
                Nothing ->
                    ( 200, 100 )

                Just inspectedId ->
                    if id == inspectedId then
                        ( 100, 200 )

                    else
                        ( 200, 100 )
    in
    wrappedRow [ spacing 18 ] <|
        List.map
            (\mod -> viewMod mod (getModHeight mod.id))
            installedMods


viewMod : InstalledMod -> ( Int, Int ) -> Element Msg
viewMod mod ( nameHeight, imageHeight ) =
    column
        [ height (px 300)
        , width (px 250)
        , padding 10
        , Border.rounded 8
        , Border.shadow
            { offset = ( 0, 0 )
            , size = 1.0
            , blur = 3.0
            , color = colors.backgroundDark
            }
        , Events.onMouseEnter (InspectCard mod.id)
        ]
        [ image
            [ width fill
            , height (px imageHeight)
            , centerX
            , clip
            , Border.rounded 8
            ]
            { src = mod.image.url
            , description = mod.image.description
            }
        , column
            [ width (px 250)
            , height (px nameHeight)
            , alignBottom
            , centerX
            , moveUp 20
            , paddingEach { edges | top = 10, bottom = 10 }
            , Background.color colors.background
            , Border.rounded 8
            , Border.shadow
                { offset = ( 0, -4 )
                , size = 0.1
                , blur = 4
                , color = colors.backgroundDark
                }
            ]
            [ viewName mod.name
            ]
        ]


viewName : String -> Element msg
viewName name =
    el
        [ centerX
        , height fill
        , Font.color colors.fontLight
        ]
        (text (String.ellipsis 28 name))