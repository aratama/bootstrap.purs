module Render where

import Data.Unit (Unit)
import Data.Void (Void)
import Halogen.HTML (HTML, text)
import Halogen.HTML.Elements (div, h2, button, br, img)
import Halogen.HTML.Events (input_, onClick)
import Halogen.HTML.Properties (src)
import Type (State, Query(..))

render :: State -> HTML Void (Query Unit)
render state = div [] [
    h2 [] [text state.topic],
    button [ onClick (input_ MorePlease) ] [ text "More Please!" ],
    br [],
    img [src state.gifUrl]
]
