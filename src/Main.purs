module Main where

import Control.Monad.Eff (Eff)
import Halogen (Component, ComponentDSL, ComponentHTML, HalogenEffects, component, modify, runUI)
import Halogen.HTML.Events.Indexed (input_, onClick)
import Halogen.HTML.Indexed (button, div_, h1_, p_, text)
import Halogen.Util (awaitBody, runHalogenAff)
import Prelude (type (~>), Unit, bind, not, pure)

data Query a = ToggleState a

type State = { on :: Boolean }

initialState :: State
initialState = { on: false }

ui :: forall g. Component State Query g
ui = component { render, eval }
  where

    render :: State -> ComponentHTML Query
    render state = div_ [
        h1_ [text "Hello world!"],
        p_ [text "Why not toggle this button:"],
        button [
            onClick (input_ ToggleState)
        ] [
            text if not state.on
                then "Don't push me"
                else "I said don't push me!"
        ]
    ]

    eval :: Query ~> ComponentDSL State Query g
    eval (ToggleState next) = do
        modify (\state -> { on: not state.on })
        pure next

main :: Eff (HalogenEffects ()) Unit
main = runHalogenAff do
    body <- awaitBody
    runUI ui initialState body