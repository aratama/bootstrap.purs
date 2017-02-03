module Main where

import Control.Category ((<<<))
import Control.Applicative (pure)
import Control.Bind (class Bind, bind, (>>=))
import Control.Monad.Aff (Aff, attempt)
import Control.Monad.Aff.Class (class MonadAff, liftAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (error)
import Control.Monad.Error.Class (throwError)
import Control.Monad.Except (runExcept)
import Control.Monad.State (modify)
import Control.Monad.State.Class (class MonadState, get)
import Data.Either (Either(..), either)
import Data.Foreign (Foreign)
import Data.Foreign.Class (readProp)
import Data.Maybe (Maybe(..))
import Data.Monoid ((<>))
import Data.NaturalTransformation (type (~>))
import Data.Show (show)
import Data.Unit (Unit, unit)
import Data.Void (Void)
import Halogen (Component)
import Halogen.Aff (HalogenEffects)
import Halogen.Aff.Util (runHalogenAff, awaitBody)
import Halogen.Component (component)
import Halogen.HTML (text)
import Halogen.HTML.Core (HTML)
import Halogen.HTML.Elements (br, button, div, h2, img)
import Halogen.HTML.Events (input_, onClick)
import Halogen.HTML.Properties (src)
import Halogen.Query (action)
import Halogen.VDom.Driver (runUI)
import Network.HTTP.Affjax (AJAX)
import Network.HTTP.Affjax (get) as Ajax

loading :: String
loading = "loading.svg"

type State = {
    topic :: String,
    gifUrl :: String
}

data Query a = MorePlease a

type Effects eff = HalogenEffects (ajax :: AJAX | eff)

render :: State -> HTML Void (Query Unit)
render model = div [] [
    h2 [] [text model.topic],
    button [ onClick (input_ MorePlease) ] [ text "More Please!" ],
    br [],
    img [src model.gifUrl]
]

eval :: forall m eff. (MonadAff (Effects eff) m, MonadState State m, Bind m) => Query ~> m
eval msg = case msg of
    MorePlease next -> do
        modify _ { gifUrl = loading }
        model <- get
        let url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" <> model.topic
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

ui :: forall i o m eff. (MonadAff (Effects eff) m) => Component HTML Query i o m
ui = component {
    render,
    eval,
    initialState: \_ -> init "cats",
    receiver: \_ -> Nothing
}
  where
    init :: String -> State
    init topic = { topic, gifUrl: loading }

main :: forall eff. Eff (Effects eff) Unit
main = runHalogenAff do
    body <- awaitBody
    io <- runUI ui unit body
    io.query (action MorePlease)
