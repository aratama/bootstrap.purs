module Main where

import Prelude (bind, pure, discard, ($))
import Effect.Console (log)
import Effect (Effect)
import Data.Unit (Unit, unit)
import Halogen (tell, liftEffect)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.VDom.Driver (runUI)
import Bootstrap.Type (Query(..))
import Bootstrap.UI (component)

main :: Effect Unit
main =
  runHalogenAff do
    body <- awaitBody
    liftEffect $ log $ "start"
    io <- runUI component "rabbits" body
    _ <- io.query (tell (MorePlease))
    pure unit
