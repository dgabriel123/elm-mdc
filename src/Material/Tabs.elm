module Material.Tabs
    exposing
        (
          -- VIEW
          view

          -- PROPERTIES
        , Property
        , scroller
        , indicatorPrimary
        , indicatorAccent
        , indicator

          -- TABS
        , tab
        , withIconAndText
        , icon
        , iconLabel

          -- TEA
        , subscriptions
        , Model
        , defaultModel
        , Msg
        , update

          -- RENDER
        , subs
        , render
        , Store
        , react
        )

{-|
> The MDC Tabs component contains components which are used to create
> spec-aligned tabbed navigation components adhering to the Material Design
> tabs guidelines. These components are:
>
> - mdc-tab: The individual tab elements
> - mdc-tab-bar: The main component which is composed of mdc-tab elements
> - mdc-tab-bar-scroller: The component which controls the horizontal scrolling behavior of an mdc-tab-bar that overflows its container

## Design & API Documentation

- [Material Design guidelines: Tabs](https://material.io/guidelines/components/tabs.html)
- [Demo](https://aforemny.github.io/elm-mdc/#tabs)

## View
@docs view

## Properties
@docs Property
@docs scroller
@docs indicatorPrimary, indicatorAccent, indicator

## Tabs
@docs tab
@docs withIconAndText
@docs icon
@docs iconLabel

## TEA
@docs Model, defaultModel, Msg, update

## Render
@docs render, Store, react
-}

import AnimationFrame
import Dict exposing (Dict)
import DOM
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed)
import Material.Dispatch as Dispatch
import Material.Helpers exposing (map1st)
import Material.Internal.Options as Internal
import Material.Internal.Tabs exposing (Msg(..), Geometry, defaultGeometry)
import Material.Msg exposing (Index)
import Material.Options as Options exposing (Style, styled, cs, css, when)
import Material.Ripple as Ripple
import Window


type alias Model =
    { index : Int
    , geometry : Geometry
    , translationOffset : Float
    , scale : Float
    , nextIndicator : Bool
    , backIndicator : Bool
    , ripples : Dict Int Ripple.Model
    , initialized : Bool
    , requestAnimation : Bool
    }


defaultModel : Model
defaultModel =
    { index = 0
    , geometry = defaultGeometry
    , translationOffset = 0
    , scale = 0
    , nextIndicator = False
    , backIndicator = False
    , ripples = Dict.empty
    , initialized = False
    , requestAnimation = True
    }


type alias Msg m
    = Material.Internal.Tabs.Msg m


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        RippleMsg index msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_
                      ( Dict.get index model.ripples
                        |> Maybe.withDefault Ripple.defaultModel
                      )
            in
            ( { model | ripples = Dict.insert index ripple model.ripples }
            ,
              Cmd.map (RippleMsg index >> lift) effects
            )

        Dispatch msgs ->
            ( model, Dispatch.forward msgs )

        Select index geometry ->
            ( { model
                  | index = index
                  , scale = computeScale geometry index
              }
            ,
              Cmd.none
            )

        ScrollBackward geometry ->
            let
                concealedTabs =
                    List.reverse geometry.tabs
                    |> List.indexedMap (\index tab ->
                           let
                              tabRight =
                                  tab.offsetLeft + tab.width
                           in
                           if tabRight + model.translationOffset < 0 then
                               Just (index, tab)
                           else
                               Nothing
                       )
                    |> List.filterMap identity

                scrollFrameWidth =
                    geometry.scrollFrame.width

                translationOffset =
                    concealedTabs
                    |> List.foldl
                       (\(_, tab) (accum, translationOffset) ->
                             let
                                accum_ =
                                    accum + tab.width
                             in
                             if accum_ > scrollFrameWidth then
                                 (accum, -tab.offsetLeft)
                             else
                                 (accum_, -tab.offsetLeft)
                       )
                       (0, model.translationOffset)
                    |> Tuple.second

                totalTabsWidth =
                    computeTotalTabsWidth geometry
            in
            ( { model
                  | geometry = geometry
                  , translationOffset = translationOffset
                  , nextIndicator = totalTabsWidth + translationOffset > scrollFrameWidth
                  , backIndicator = translationOffset < 0
              }
            ,
              Cmd.none
            )
        ScrollForward geometry ->
            let
                concealedTabs =
                    geometry.tabs
                    |> List.indexedMap (\index tab ->
                           let
                              tabRight =
                                  tab.offsetLeft + tab.width
                           in
                           if tabRight + model.translationOffset > scrollFrameWidth then
                               Just (index, tab)
                           else
                               Nothing
                       )
                    |> List.filterMap identity

                scrollFrameWidth =
                    geometry.scrollFrame.width

                translationOffset =
                    concealedTabs
                    |> List.head
                    |> Maybe.map (\(_, tab) -> -tab.offsetLeft)
                    |> Maybe.withDefault model.translationOffset

                totalTabsWidth =
                    computeTotalTabsWidth geometry
            in
            ( { model
                  | geometry = geometry
                  , translationOffset = translationOffset
                  , nextIndicator = totalTabsWidth + translationOffset > scrollFrameWidth
                  , backIndicator = translationOffset < 0
              }
            ,
              Cmd.none
            )

        Init geometry ->
            ( let
                  totalTabsWidth =
                      List.foldl (\tab accum -> tab.width + accum) 0 geometry.tabs
              in
              { model
                  | geometry = geometry
                  , scale = computeScale geometry 0
                  , nextIndicator = totalTabsWidth > geometry.scrollFrame.width
                  , backIndicator = False
                  , initialized = True
              }
            ,
              Cmd.none
            )

        Resize ->
            ( { model | requestAnimation = True }, Cmd.none )

        AnimationFrame ->
            if model.requestAnimation then
                ( { model
                    | requestAnimation = False
                    , initialized = True
                  }
                ,
                  Cmd.none
                )
            else
                ( model, Cmd.none )


type alias Config =
    { active : Int
    , scroller : Bool
    , indicator : Bool
    }


defaultConfig : Config
defaultConfig =
    { active = 0
    , scroller = False
    , indicator = False
    }


scroller : Property m
scroller =
    Internal.option (\config -> { config | scroller = True })


withIconAndText : Property m
withIconAndText =
    cs "mdc-tab--with-icon-and-text"


indicatorPrimary : Property m
indicatorPrimary =
    cs "mdc-tab-bar--indicator-primary"


indicatorAccent : Property m
indicatorAccent =
    cs "mdc-tab-bar--indicator-accent"


indicator : Property m
indicator =
    Internal.option (\config -> { config | indicator = True })


tab : List (Property m)
    -> List (Html m)
    -> { node : List (Property m) -> List (Html m) -> Html m
       , options : List (Property m)
       , childs : List (Html m)
       }
tab options childs =
    { node = \options childs -> styled Html.div options childs
    , options = options
    , childs = childs
    }


icon : List (Style m) -> String -> Html m
icon options icon =
    styled Html.i [ cs "mdc-tab__icon", cs "material-icons" ] [ text icon ]


iconLabel : List (Style m) -> String -> Html m
iconLabel options str =
    styled Html.span [ cs "mdc-tab__icon-text" ] [ text str ]


type alias Property m =
    Options.Property (Config) m


view
    : (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List { node : List (Property m) -> List (Html m) -> Html m
            , options : List (Property m)
            , childs : List (Html m)
            }
    -> Html m
view lift model options nodes =
    let
        summary =
            Internal.collect defaultConfig options

        config =
            summary.config

        numTabs =
            List.length nodes

        tabBarTransform =
            "translateX(" ++ toString model.translationOffset ++ "px)"

        indicatorTransform =
            let
                tabLeft =
                    model.geometry.tabs
                    |> List.drop model.index
                    |> List.head
                    |> Maybe.map .offsetLeft
                    |> Maybe.withDefault 0
            in
            [ "translateX(" ++ toString tabLeft ++ "px)"
            , "scale(" ++ toString model.scale ++ ",1)"
            ]
            |> String.join " "

        tabBarScroller tabBar =
            styled Html.div
            [ cs "mdc-tab-bar-scroller"
            ]
            [ styled Html.div
              [ cs "mdc-tab-bar-scroller__indicator"
              , cs "mdc-tab-bar-scroller__indicator--back"
              , cs "mdc-tab-bar-scroller__indicator--enabled"
              , css "display" "none" |> when (not model.backIndicator)
              , Options.on "click" (Json.map (ScrollBackward >> lift) (decodeGeometryOnIndicator config.indicator))
              ]
              [ styled Html.a
                [ cs "mdc-tab-bar__indicator__inner"
                , cs "material-icons"
                , css "pointer-events" "none"
                ]
                [ text "navigate_before"
                ]
              ]
            , styled Html.div
              [ cs "mdc-tab-bar-scroller__scroll-frame"
              ]
              [ tabBar
              ]
            , styled Html.div
              [ cs "mdc-tab-bar-scroller__indicator"
              , cs "mdc-tab-bar-scroller__indicator--next"
              , cs "mdc-tab-bar-scroller__indicator--enabled"
              , Options.on "click" (Json.map (ScrollForward >> lift) (decodeGeometryOnIndicator config.indicator))
              , css "display" "none" |> when (not model.nextIndicator)
              ]
              [ styled Html.a
                [ cs "mdc-tab-bar__indicator__inner"
                , cs "material-icons"
                , css "pointer-events" "none"
                ]
                [ text "navigate_next"
                ]
              ]
            ]

        hasIndicator =
            config.indicator

        rippleStyles =
            nodes
            |> List.indexedMap (\ index _ ->
                 Ripple.view False (RippleMsg index >> lift)
                   ( Dict.get index model.ripples
                     |> Maybe.withDefault Ripple.defaultModel
                   )
                   () ()
               )
            |> List.map Tuple.second
    in
        (if config.scroller then tabBarScroller else identity) <|
        Internal.apply summary
            Html.nav
            [ cs "mdc-tab-bar"
            , cs "mdc-tab-bar-upgraded"
            , Options.many
              [ cs "mdc-tab-bar-scroller__scroller-frame__tabs"
              , css "transform" tabBarTransform
              ]
            , Options.on "elm-mdc-init"
                  (Json.map (Init >> lift)
                  (decodeGeometryOnTabBar config.indicator))
            , cs "elm-mdc-tab-bar--uninitialized"
                |> when model.requestAnimation
            ]
            [
            ]
            ( List.concat
              [ nodes
                |> List.indexedMap (\index { node, options, childs }  ->
                       let
                          ( rippleOptions, _ ) =
                              Ripple.view False (RippleMsg index >> lift)
                                ( Dict.get index model.ripples
                                  |> Maybe.withDefault Ripple.defaultModel
                                )
                                () ()
                       in
                       [ node
                           ( cs "mdc-tab"
                           :: when (model.index == index) (cs "mdc-tab--active")
                           :: Options.on "click" (Json.map (Select index >> lift) (decodeGeometryOnTab hasIndicator))
                           :: Options.dispatch (Dispatch >> lift)
                           :: rippleOptions
                           :: options
                           )
                           childs
                       ]
                   )
                |> List.concat

              , if config.indicator then
                    [ styled Html.div
                      [ cs "mdc-tab-bar__indicator"
                      , css "display" "none" |> when (not (hasIndicator && model.initialized))
                      , css "transform" indicatorTransform
                      , css "visibility" "visible" |> when (numTabs > 0)
                      ]
                      []
                    ]
                else
                    []

              , rippleStyles
              ]
            )


type alias Store s =
    { s | tabs : Indexed Model }


( get, set ) =
    Component.indexed .tabs (\x y -> { y | tabs = x }) defaultModel


react :
    (Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react lift msg idx store =
    update lift msg (get idx store) |> map1st (set idx store >> Just)


render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List { node : List (Property m) -> List (Html m) -> Html m
            , options : List (Property m)
            , childs : List (Html m)
            }
    -> Html m
render =
    Component.render get view Material.Msg.TabsMsg


computeScale : Geometry -> Int -> Float
computeScale geometry index =
    let
        totalTabsWidth =
            computeTotalTabsWidth geometry
    in
    case List.head (List.drop index geometry.tabs) of
        Nothing ->
            1
        Just tab ->
            if totalTabsWidth == 0 then
                1
            else
                tab.width / totalTabsWidth


computeTotalTabsWidth : Geometry -> Float
computeTotalTabsWidth geometry =
    List.foldl (\tab accum -> tab.width + accum) 0 geometry.tabs


decodeGeometryOnIndicator : Bool -> Decoder Geometry
decodeGeometryOnIndicator hasIndicator =
    DOM.target        <| -- .mdc-tab-bar-scroller__indicator
    DOM.parentElement <| -- .mdc-tab-bar-scroller
    DOM.childNode 1   <| -- .mdc-tab-bar-scroller__scroll-frame
    DOM.childNode 0   <| -- .mdc-tab-bar
    decodeGeometry hasIndicator


decodeGeometryOnTab : Bool -> Decoder Geometry
decodeGeometryOnTab hasIndicator =
    DOM.target        <| -- .mdc-tab
    DOM.parentElement <| -- .mdc-tab-bar
    decodeGeometry hasIndicator


decodeGeometryOnTabBar : Bool -> Decoder Geometry
decodeGeometryOnTabBar hasIndicator =
    DOM.target <| -- .mdc-tab-bar
    decodeGeometry hasIndicator


decodeGeometry : Bool -> Decoder Geometry
decodeGeometry hasIndicator =
    Json.map2
        (\tabs scrollFrame -> { tabs = tabs, scrollFrame = scrollFrame })
        ( (Json.map (if hasIndicator then (\xs -> List.take ((List.length xs) - 1) xs) else identity)) <|
          Json.map (List.filterMap identity) <|
          DOM.childNodes
            ( Json.at [ "tagName" ] Json.string
              |> Json.andThen (\ tagName ->
                    case String.toLower tagName of
                        "style" ->
                            Json.succeed Nothing
                        _ ->
                            Json.map Just <|
                            Json.map2
                                (\offsetLeft width ->
                                    { offsetLeft = offsetLeft, width = width }
                                )
                                DOM.offsetLeft
                                DOM.offsetWidth
                 )
            )
        )
        ( DOM.parentElement <| -- .mdc-tab-bar-scroller__scroll-frame
          Json.map (\width -> { width = width }) DOM.offsetWidth
        )


subscriptions : Model -> Sub (Msg m)
subscriptions model =
    Sub.batch
    [
      Window.resizes (always Resize)
    ,
      if model.requestAnimation then
          AnimationFrame.times (always AnimationFrame)
      else
          Sub.none
    ]


subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Material.Msg.TabsMsg .tabs subscriptions
