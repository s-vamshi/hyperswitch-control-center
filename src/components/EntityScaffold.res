@react.component
let make = (
  ~entityName="",
  ~remainingPath,
  ~isAdminAccount=false,
  ~access: CommonAuthTypes.authorization=Access,
  ~renderList,
  ~renderNewForm=_ => React.null,
  ~renderShow=(_, _) => React.null,
) => {
  if access === NoAccess {
    <UnauthorizedPage />
  } else {
    switch remainingPath {
    | list{"new"} => renderNewForm()
    | list{id} => renderShow(id, None)
    | list{id, key} => renderShow(id, Some(key))
    | list{} => renderList()
    | _ => <NotFoundPage />
    }
  }
}
