INTERFACE zif_proubc_testobj
  PUBLIC .


  TYPES:
    BEGIN OF ty_obtrigtest,
      bpi_tenant_id        TYPE zprvdtenants-tenant_id,
      status               TYPE i, "status 201, 400, etc
      bpi_response_payload TYPE string,
      bpi_endpoint         TYPE string,
      msg_payload          TYPE zif_proubc_baseline=>protocolmessage_req,
    END OF ty_obtrigtest .
ENDINTERFACE.
