#!/bin/sh

ELMTEMPLATE="module Main exposing (Model, Msg, main)

import Browser
import Html exposing (Html, button, h3, main_, p, text)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    Int


init : () -> ( Model, Cmd Msg )
init _ =
    ( 0, Cmd.none )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model - 1, Cmd.none )

        Reset ->
            ( 0, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    main_ []
        [ h3 [] [ text \"Elm counter\" ]
        , p [] [ text <| String.fromInt model ]
        , button [ onClick Increment ] [ text \"+\" ]
        , button [ onClick Decrement ] [ text \"-\" ]
        , button [ onClick Reset ] [ text \"Reset\" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
"


JSTEMPLATE="import { Elm } from \"./src/Main.elm\";
Elm.Main.init({ node: document.getElementById(\"app\") });
"


HTMLTEMPLATE="<!DOCTYPE html>
<html lang=\"en\">

<head>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Elm App</title>
    <link rel=\"manifest\" href=\"app.webmanifest\">
    <link rel=\"stylesheet\" href=\"style.sass\">
    <script type=\"module\" src=\"index.js\"></script>
</head>
<body>
    <main id=\"app\"></main>
</body>
</html>"

VITECONFIGTEMPLATE="import { defineConfig } from 'vite'
import elmPlugin from 'vite-plugin-elm'

export default defineConfig({
    plugins: [elmPlugin()]
})"

SASSTEMPLATE="*
    padding: 0
    margin: 0
    box-sizing: border-box

body
    background: #262626
    color: beige
    font-family: Arial, Helvetica, sans-serif
"

GITIGNORETEMPLATE=".cache
dist
elm-stuff
node_modules"

APPMANIFESTTEMPLATE="{
    \"theme_color\": \"#262626\",
    \"background_color\": \"#262626\",
    \"display\": \"fullscreen\",
    \"scope\": \"/\",
    \"start_url\": \"/\",
    \"name\": \"Elm App\",
    \"short_name\": \"ElmApp\",
    \"description\": \"Elm app description\"
}"

# create project folder
mkdir $1
cd $1

# install npm dependencies
npm i -D vite
npm i -D vite-plugin-elm@next
npm i -D sass


# init elm
elm init

# init elm-test
elm-test init

# init elm review
elm-review init --template jfmengels/elm-review-config/application


# write template files
echo "$ELMTEMPLATE" > src/Main.elm

echo "$JSTEMPLATE" > index.js

echo "$HTMLTEMPLATE" > index.html

echo "$VITECONFIGTEMPLATE" > vite.config.js

echo "$SASSTEMPLATE" > style.sass

echo "$GITIGNORETEMPLATE" > .gitignore

echo "$APPMANIFESTTEMPLATE" > app.webmanifest
# start vscode
code .

# start live server
vite --host --open http://localhost:5173/