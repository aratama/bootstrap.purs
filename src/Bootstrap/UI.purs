module Bootstrap.UI (ui) where

import Bootstrap.Render (render)
import Bootstrap.Type (Input, Output, Query(..), State, Giphy)
import Control.Monad.State (modify)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class (liftAff)
import Effect.Class.Console (errorShow)
import Halogen (Component)
import Halogen.Component (ComponentDSL, component)
import Halogen.HTML.Core (HTML)
import Network.HTTP.Affjax (URL)
import Network.HTTP.Affjax (get) as Ajax
import Network.HTTP.Affjax.Response (string)
import Prelude
import Simple.JSON (readJSON)

loading :: URL
loading = "loading.svg"

giphy :: String -> URL
giphy topic = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" <> topic

eval :: Query ~> ComponentDSL State Query Output Aff
eval = case _ of
    MorePlease next -> next <$ do
        state <- modify _ { gifUrl = loading }
        res <- liftAff $ Ajax.get string (giphy state.topic)
        case readJSON res.response of 
            Left err -> errorShow err 
            Right (json :: Giphy) -> void do 
                modify _ { gifUrl = json.data.image_url }

ui :: Component HTML Query Input Output Aff
ui = component {
    render,
    eval,
    initialState: \topic -> { topic, gifUrl: loading },
    receiver: \_ -> Nothing
}
