CLASS zcl_idocapi_btypeapi DEFINITION
  PUBLIC
  INHERITING FROM cl_rest_resource
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS if_rest_resource~get
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_IDOCAPI_BTYPEAPI IMPLEMENTATION.


  METHOD if_rest_resource~get.
*CALL METHOD SUPER->IF_REST_RESOURCE~GET
*    .

    DATA: lt_basictypes TYPE zif_idocapi_typelist=>tt_basictype.

    SELECT  a~idoctyp
            b~descrp
            a~presp
            a~pwork
            a~plast
            a~closed
            a~released
            a~pretyp
            a~generated
            a~credate
            a~cretime
            a~ldate
            a~ltime
            a~applrel
      FROM edbas AS a
      LEFT OUTER JOIN edbast AS b ON a~idoctyp = b~idoctyp
                                  AND b~langua = 'E'
      INTO TABLE lt_basictypes.

    IF sy-subrc = 0.
      DATA(lo_entity) = mo_response->create_entity( ).
      lo_entity->set_content_type( if_rest_media_type=>gc_appl_json ).
      lo_entity->set_string_data( /ui2/cl_json=>serialize( EXPORTING data = lt_basictypes pretty_name = /ui2/cl_json=>pretty_mode-low_case ) ).
      mo_response->set_status( cl_rest_status_code=>gc_success_ok ).
    ENDIF.


  ENDMETHOD.
ENDCLASS.
