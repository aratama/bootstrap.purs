module UI where

import Control.Applicative (pure)
import Control.Bind (bind, (>>=))
import Control.Category ((<<<))
import Control.Monad.Aff (Aff, attempt)
import Control.Monad.Aff.Class (liftAff)
import Control.Monad.Eff.Exception (error)
import Control.Monad.Error.Class (throwError)
import Control.Monad.Except (runExcept)
import Control.Monad.State (modify)
import Control.Monad.State.Class (get)
import Data.Either (Either(..), either)
import Data.Foreign (Foreign)
import Data.Foreign.Class (readProp)
import Data.Maybe (Maybe(..))
import Data.Monoid ((<>))
import Data.NaturalTransformation (type (~>))
import Data.Show (show)
import Halogen (Component)
import Halogen.Component (ComponentDSL, component)
import Halogen.HTML.Core (HTML)
import Network.HTTP.Affjax (get) as Ajax
import Type (Input, Output, Query(..), State, Effects)
import Render (render)

loading :: String
loading = "loading.svg"

eval :: forall eff. Query ~> ComponentDSL State Query Output (Aff (Effects eff))
eval msg = case msg of
    MorePlease next -> do
        modify _ { gifUrl = loading }
        state <- get
        let url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" <> state.topic
        response <- liftAff (attempt (Ajax.get url))
        case response of
            Left err -> pure next
            Right res -> do
                newUrl <- liftAff (decodeGifUrl res.response)
                modify _ { gifUrl = newUrl }
                pure next

  where

    decodeGifUrl :: Foreign -> Aff (Effects eff) String
    decodeGifUrl value = do
        let parsed = readProp "data" value >>= readProp "image_url"
        either (throwError <<< error <<< show) pure (runExcept parsed)

ui :: forall eff. Component HTML Query Input Output (Aff (Effects eff))
ui = component {
    render,
    eval,
    initialState: \topic -> { topic, gifUrl: loading },
    receiver: \_ -> Nothing
}
