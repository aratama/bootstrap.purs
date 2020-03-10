module Bootstrap.Render where

import Halogen.HTML (ComponentHTML, text)
import Halogen.HTML.Elements (div, h2, button, br, img)
import Halogen.HTML.Events (onClick)
import Halogen.HTML.Properties (src)
import Bootstrap.Type (State, Action(..))
import Data.Maybe (Maybe(Just))
import Effect.Aff (Aff)

render :: State -> ComponentHTML Action () Aff
render state =
  div []
    [ h2 [] [ text state.topic ]
    , button [ onClick (\_ -> Just (FetchImage)) ] [ text "More Please!" ]
    , br []
    , img [ src state.gifUrl ]
    ]
