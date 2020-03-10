module Main where

import Prelude (bind, pure, discard, ($))
import Effect.Console (log)
import Effect (Effect)
import Data.Unit (Unit, unit)
import Halogen (liftEffect)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.VDom.Driver (runUI)
import Bootstrap.UI (component)

main :: Effect Unit
main =
  runHalogenAff do
    body <- awaitBody
    liftEffect $ log $ "start"
    io <- runUI component "rabbits" body
    pure unit
