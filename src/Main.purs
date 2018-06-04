module Main where

import Prelude (bind)
import Effect (Effect)
import Data.Unit (Unit)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.Query (action)
import Halogen.VDom.Driver (runUI)
import Bootstrap.Type (Query(MorePlease))
import Bootstrap.UI (ui)

main :: Effect Unit
main = runHalogenAff do
    body <- awaitBody
    io <- runUI ui "cats" body
    io.query (action MorePlease)
