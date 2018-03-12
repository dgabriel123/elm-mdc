module Material.Drawer.Persistent exposing
    ( content
    , header
    , headerContent
    , toggleOn
    , Property
    , toolbarSpacer
    , view
    )

{-| The Drawer component is a spec-aligned drawer component adhering to the
Material Design navigation drawer pattern. It implements permanent, persistent,
and temporary drawers.


# Resources

- [Material Design guidelines: Navigation drawer](https://material.io/guidelines/patterns/navigation-drawer.html)
- [Demo: Temporary Drawer](https://aforemny.github.io/elm-mdc/#temporary-drawer)
- [Demo: Persistent Drawer](https://aforemny.github.io/elm-mdc/#persistent-drawer)
- [Demo: Permanent Drawer Above Toolbar](https://aforemny.github.io/elm-mdc/#permanent-drawer-above)
- [Demo: Permanent Drawer Below Toolbar](https://aforemny.github.io/elm-mdc/#permanent-drawer-below)


# Example


```elm
import Html exposing (text)
import Material.Drawer.Persistent as Drawer
import Material.List as Lists


Drawer.view Mdc [0] model.mdc []
    [ Drawer.header []
          [ Drawer.headerContent []
                [ text "Header here"
                ]
          ]
    , Lists.ul
          [ Drawer.content
          ]
          [ Lists.li []
                [ Lists.graphicIcon [] "inbox"
                , text "Inbox"
                ]
          , Lists.li []
                [ Lists.graphicIcon [] "star"
                , text "Star"
                ]
          , Lists.li []
                [ Lists.graphicIcon [] "send"
                , text "Sent Mail"
                ]
          , Lists.li []
                [ Lists.graphicIcon [] "drafts"
                , text "Drafts"
                ]
          ]
    ]
```


# Usage

@docs Property
@docs view
@docs content
@docs toolbarSpacer
@docs header
@docs headerContent
@docs toggleOn
-}

import Html exposing (Html, text)
import Json.Decode as Json
import Material.Drawer as Drawer
import Material.Internal.Drawer
import Material.List as Lists
import Material.Msg exposing (Index)
import Material.Options as Options


type alias Model =
    Drawer.Model


defaultModel : Model
defaultModel =
    Drawer.defaultModel


type alias Msg
    = Drawer.Msg


update : x -> Msg -> Model -> ( Maybe Model, Cmd m )
update =
    Drawer.update


type alias Config =
    Drawer.Config


defaultConfig : Config
defaultConfig =
    Drawer.defaultConfig


{-| Drawer property.
-}
type alias Property m =
    Drawer.Property m


{-| Container to create a 16:9 drawer header.
-}
header : List (Property m) -> List (Html m) -> Html m
header =
    Drawer.header


{-| Content node inside `header`.
-}
headerContent : List (Property m) -> List (Html m) -> Html m
headerContent =
    Drawer.headerContent


{-| Should be set on the list of items inside the drawer.
-}
content : Lists.Property m
content =
    Drawer.content


{-| Provide the matching amount of space for toolbar.
-}
toolbarSpacer : List (Property m) -> List (Html m) -> Html m
toolbarSpacer =
    Drawer.toolbarSpacer


type alias Store s =
    Drawer.Store s


{-| Drawer view.
-}
view :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Drawer.render className


react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Drawer.react


subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Drawer.subs


subscriptions : Model -> Sub Msg
subscriptions =
    Drawer.subscriptions


{-| Toggles the drawer on interaction.

```elm
import Html exposing (text)
import Material.Button as Button

Button.view Mdc [0] model.mdc
    [ Drawer.toggleOn Mdc [1] "click"
    ]
    [ text "Toggle Drawer with ID [1]"
    ]
```
-}
toggleOn : (Material.Msg.Msg m -> m) -> Index -> String -> Options.Property c m
toggleOn lift index event =
    Options.on event (Json.succeed (lift (Material.Msg.DrawerMsg index (Material.Internal.Drawer.Toggle True))))


className : String
className =
    "mdc-drawer--persistent"