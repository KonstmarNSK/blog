module Messages exposing (..)


-- Update accepts this type
type Message =
   SidebarMsg SidebarMsg



-- Messages that sidebar items produce
type SidebarMsg =
    SidebarItemClicked ShowSubpage

type ShowSubpage =
    --LoadedPage String modelType
    NotLoadedPage String String




