module PageParts.Common exposing (ElementEvent, onClick, toAttribute)

import Element exposing (Attribute)
import Element.Events
import Messages.Messages exposing (Message)




type alias Internal msg = Attribute msg


-- encapsulates element attributes like 'Events.onClick'
type ElementEvent msg =
    OnClick (Internal msg)



onClick: Message -> ElementEvent Message
onClick msg =
    OnClick (Element.Events.onClick msg)


toAttribute: ElementEvent msg -> Attribute msg
toAttribute event =
    case event of
        OnClick attr -> attr