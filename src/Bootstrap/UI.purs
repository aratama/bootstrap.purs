module Bootstrap.UI (component) where

import Prelude
import Bootstrap.Render (render)
import Bootstrap.Type (Giphy, Message, Input, Query(..), Action(..), State)
import Control.Monad.State (modify, get)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class (liftAff)
import Effect.Class.Console (errorShow)
import Halogen (HalogenM, Component, mkEval, defaultEval)
import Halogen.Component (mkComponent)
import Halogen.HTML.Core (HTML)
import Affjax (URL, printError)
import Affjax (get) as Ajax
import Affjax.ResponseFormat (string)
import Simple.JSON (readJSON)

loading :: URL
loading = "loading.svg"

giphy :: String -> URL
giphy topic = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" <> topic

fetchImage :: HalogenM State Action () Message Aff Unit
fetchImage = do
  state <- modify _ { gifUrl = loading }
  res <- liftAff $ Ajax.get string (giphy state.topic)
  case res of
    Left err -> errorShow (printError err)
    Right result -> case readJSON result.body of
      Left err -> errorShow err
      Right (json :: Giphy) ->
        void do
          modify _ { gifUrl = json.data.image_url }

handleAction :: Action -> HalogenM State Action () Message Aff Unit
handleAction = case _ of
  FetchImage -> fetchImage

handleQuery :: forall a. Query a -> HalogenM State Action () Message Aff (Maybe a)
handleQuery = case _ of
  SetTopic topic next -> do
    state <- modify _ { topic = topic }
    pure (Just next)
  GetTopic next -> do
    state <- get
    pure (Just (next state.topic))

component :: Component HTML Query Input Message Aff
component =
  mkComponent
    { render
    , eval:
        mkEval
          ( defaultEval
              { handleAction = handleAction
              , handleQuery = handleQuery
              , initialize = Just FetchImage
              }
          )
    , initialState: \topic -> { topic, gifUrl: loading }
    }
