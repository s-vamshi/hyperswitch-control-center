@react.component
let make = () => {
  open AuthProviderTypes
  open APIUtils

  let getURL = useGetURL()

  let updateDetails = useUpdateMethod()
  let (errorMessage, setErrorMessage) = React.useState(_ => "")
  let {authStatus, setAuthStatus} = React.useContext(AuthInfoProvider.authStatusContext)

  let verifyEmailWithSPT = async body => {
    try {
      open TotpUtils
      let url = getURL(
        ~entityName=USERS,
        ~methodType=Post,
        ~userType={#VERIFY_EMAILV2_TOKEN_ONLY},
        (),
      )
      let res = await updateDetails(url, body, Post, ())
      setAuthStatus(LoggedIn(TotpAuth(getTotpAuthInfo(res))))
    } catch {
    | Exn.Error(e) => {
        let err = Exn.message(e)->Option.getOr("Verification Failed")
        setErrorMessage(_ => err)
        setAuthStatus(LoggedOut)
      }
    }
  }

  React.useEffect0(() => {
    open CommonAuthUtils
    open TotpUtils
    open HSwitchGlobalVars

    RescriptReactRouter.replace(appendDashboardPath(~url="/accept_invite_from_email"))
    let emailToken = authStatus->getEmailToken

    switch emailToken {
    | Some(token) => token->generateBodyForEmailRedirection->verifyEmailWithSPT->ignore
    | None => setErrorMessage(_ => "Token not received")
    }

    None
  })
  let onClick = () => {
    RescriptReactRouter.replace(HSwitchGlobalVars.appendDashboardPath(~url="/login"))
  }

  <EmailVerifyScreen
    errorMessage onClick trasitionMessage="Verifing... You will be redirecting.."
  />
}