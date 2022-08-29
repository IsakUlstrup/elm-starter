#!/bin/sh

ELMTEMPLATE="module Main exposing (Model, Msg, main)

import Browser exposing (Document)
import Html exposing (button, h3, p, text)
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


view : Model -> Document Msg
view model =
    { title = \"Elm App\"
    , body =
        [ h3 [] [ text \"Elm counter\" ]
        , p [] [ text <| String.fromInt model ]
        , button [ onClick Increment ] [ text \"+\" ]
        , button [ onClick Decrement ] [ text \"-\" ]
        , button [ onClick Reset ] [ text \"Reset\" ]
        ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
"


JSTEMPLATE="import { Elm } from './Main.elm';

Elm.Main.init({
  node: document.querySelector('main')
});
"


HTMLTEMPLATE="<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\">
    <script defer src=\"./index.js\"></script>
  </head>
  <body>
    <main></main>
  </body>
</html>
"

GITIGNORETEMPLATE=".cache
dist
elm-stuff
node_modules"


# create project folder
mkdir $1
cd $1

# set up parcel and init elm
yarn add parcel-bundler elm
yarn run elm init

# create template FILES
echo "$ELMTEMPLATE" > src/Main.elm

echo "$JSTEMPLATE" > src/index.js

echo "$HTMLTEMPLATE" > src/index.html

echo "$GITIGNORETEMPLATE" > .gitignore

# init elm review
elm-review init --template jfmengels/elm-review-config/application


# init elm-test
elm-test init


# start vscode
code .

# start live server
yarn run parcel src/index.html --open firefox http://localhost:1234/