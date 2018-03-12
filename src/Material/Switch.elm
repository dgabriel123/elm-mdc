module Material.Switch exposing
    ( disabled
    , Model
    , on
    , Property
    , react
    , view
    )

{-|
The MDC Switch component is a spec-aligned switch component adhering to the
Material Design Switch requirements.


# Resources

- [Material Design guidelines: Switches](https://material.io/guidelines/components/selection-controls.html#selection-controls-switch)
- [Demo](https://aforemny.github.io/elm-mdc/#switch)


# Example


```elm
import Html exposing (text)
import Material.Options as Options exposing (styled)
import Material.Switch as Switch


styled Html.div
    [ cs "mdc-form-field"
    ]
    [ Switch.view Mdc [0] model.mdc
          [ Switch.on
          , Options.onClick Toggle
          ]
          []
    , Html.label
          [ Options.onClick Toggle
          ]
          [ text "on/off"
          ]
    ]
```


# Usage

@docs Property
@docs view
@docs on
@docs disabled

# Internal
@docs react
@docs Model
-}

import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material.Component as Component exposing (Indexed)
import Material.Helpers exposing (blurOn, filter, noAttr)
import Material.Internal.Options as Internal
import Material.Internal.Switch exposing (Msg(..))
import Material.Msg exposing (Index)
import Material.Options as Options exposing (cs, styled, many, when)


{-| Component model.
-}
type alias Model =
    { isFocused : Bool
    }


defaultModel : Model
defaultModel =
    { isFocused = False
    }



type alias Msg
    = Material.Internal.Switch.Msg


update : x -> Msg -> Model -> ( Maybe Model, Cmd m )
update _ msg model =
    case msg of
        SetFocus focus ->
            ( Just { model | isFocused = focus }, Cmd.none )
        NoOp ->
            ( Nothing, Cmd.none )


type alias Config =
    { value : Bool
    , disabled : Bool
    }


defaultConfig : Config
defaultConfig =
    { value = False
    , disabled = False
    }


{-| Switch property.
-}
type alias Property m =
    Options.Property Config m


{-| Disable the switch.
-}
disabled : Property m
disabled =
    Internal.option (\ config -> { config | disabled = True })


{-| Make switch display its "on" state.

Defaults to "off". Use `Options.when` to make it interactive.
-}
on : Property m
on =
    Internal.option (\config -> { config | value = True })


switch : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
switch lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    Internal.apply summary Html.div
    [ cs "mdc-switch"
    , Internal.attribute <| blurOn "mouseup"
    ]
    []
    [ styled Html.input
      [ cs "mdc-switch__native-control"
      , Internal.attribute <| Html.type_ "checkbox"
      , Internal.attribute <| Html.checked config.value
      , Internal.on1 "focus" lift (SetFocus True)
      , Internal.on1 "blur" lift (SetFocus False)
      , Options.onWithOptions "click"
          { preventDefault = True
          , stopPropagation = False
          }
          (Json.succeed (lift NoOp))
      , when config.disabled << Options.many <|
        [ cs "mdc-checkbox--disabled"
        , Options.attribute <| Html.disabled True
        ]
      ]
      []
    , styled Html.div
      [ cs "mdc-switch__background"
      ]
      [ styled Html.div
        [ cs "mdc-switch__knob"
        ]
        [
        ]
      ]
    ]


type alias Store s =
    { s | switch : Indexed Model }


( get, set ) =
    Component.indexed .switch (\x y -> { y | switch = x }) defaultModel


{-| Component react function.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.SwitchMsg update


{-| Switch view.
-}
view :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view lift index store options =
    Component.render get switch Material.Msg.SwitchMsg lift index store
        (Internal.dispatch lift :: options)
