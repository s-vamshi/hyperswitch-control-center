@react.component
let make = (
  ~isFromSettings=true,
  ~showModalFromOtherScreen=false,
  ~setShowModalFromOtherScreen=_bool => (),
) => {
  open WebhookListEntity
  let (offset, setOffset) = React.useState(_ => 0)

  let businessProfileValues =
    HyperswitchAtom.businessProfilesAtom
    ->Recoil.useRecoilValueFromAtom
    ->HSwitchMerchantAccountUtils.getArrayOfBusinessProfile

  <UIUtils.RenderIf condition=isFromSettings>
    <div className="relative h-full">
      <div className="flex flex-col-reverse md:flex-col">
        <PageUtils.PageHeading
          title="Webhooks"
          subTitle="Set up and monitor transaction webhooks for real-time notifications."
        />
        <LoadedTable
          title="Webhooks"
          hideTitle=true
          resultsPerPage=7
          visibleColumns
          entity={webhookProfileTableEntity}
          showSerialNumber=true
          actualData={businessProfileValues->Js.Array2.map(Js.Nullable.return)}
          totalResults={businessProfileValues->Js.Array2.length}
          offset
          setOffset
          currrentFetchCount={businessProfileValues->Js.Array2.length}
        />
      </div>
    </div>
  </UIUtils.RenderIf>
}