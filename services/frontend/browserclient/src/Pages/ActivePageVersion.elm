module Pages.ActivePageVersion exposing (ActivePageVersion, increment, ident, equals)

-- used in MainPage
type ActivePageVersion = Inner Int

increment: ActivePageVersion -> ActivePageVersion
increment activePageVersion =
    case activePageVersion of
        Inner ver -> Inner <|  ver + 1

ident: ActivePageVersion
ident = Inner 0

equals: ActivePageVersion -> ActivePageVersion -> Bool
equals activePageVersion activePageVersion2 =
    case (activePageVersion, activePageVersion2) of
            (Inner ver1, Inner ver2) -> ver1 == ver2

