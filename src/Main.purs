module Main where

import Control.Bind (bind, discard)
import Control.Monad.Eff (Eff)
import Data.Unit (Unit)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.Query (action)
import Halogen.VDom.Driver (runUI)
import Type (Effects, Query(MorePlease))
import UI (ui)

main :: forall eff. Eff (Effects eff) Unit
main = runHalogenAff do
    body <- awaitBody
    io <- runUI ui "cats" body
    io.query (action MorePlease)
