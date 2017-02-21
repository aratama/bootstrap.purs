module UI (ui) where

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
import Control.Plus ((<$))
import Data.Either (Either(..), either)
import Data.Foreign (Foreign)
import Data.Foreign.Class (readProp)
import Data.Maybe (Maybe(..))
import Data.Monoid ((<>))
import Data.NaturalTransformation (type (~>))
import Data.Show (show)
import Data.Unit (unit)
import Halogen (Component)
import Halogen.Component (ComponentDSL, component)
import Halogen.HTML.Core (HTML)
import Network.HTTP.Affjax (get) as Ajax
import Render (render)
import Type (Input, Output, Query(..), State, Effects)

loading :: String
loading = "loading.svg"

giphy :: String
giphy = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag="

eval :: forall eff. Query ~> ComponentDSL State Query Output (Aff (Effects eff))
eval = case _ of
    MorePlease next -> next <$ do
        modify _ { gifUrl = loading }
        state <- get
        liftAff (attempt (Ajax.get (giphy <> state.topic))) >>= case _ of
            Left err -> pure unit
            Right res -> do
                newUrl <- liftAff (decodeGifUrl res.response)
                modify _ { gifUrl = newUrl }
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
