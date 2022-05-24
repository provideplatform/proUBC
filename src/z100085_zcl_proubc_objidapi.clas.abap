CLASS z100085_zcl_proubc_objidapi DEFINITION
  PUBLIC
  INHERITING FROM cl_rest_resource
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS if_rest_resource~get
        REDEFINITION .
    METHODS if_rest_resource~put
        REDEFINITION .
    METHODS if_rest_resource~post
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z100085_zcl_proubc_objidapi IMPLEMENTATION.


  METHOD if_rest_resource~get.
    "/objects/{ID}
    DATA(lt_uriattributes) = mo_request->get_uri_attributes( ).
    DATA(lo_entity) = mo_response->create_entity( ).
    READ TABLE lt_uriattributes WITH KEY name = 'ID' ASSIGNING FIELD-SYMBOL(<fs_object_get>).
    IF sy-subrc = 0.
      DATA lv_objectid TYPE z100085_bpiobj-object_id.
      DATA lt_object TYPE  z100085_ztty_bpiobj.
      DATA ls_object TYPE z100085_bpiobj.
      DATA lv_bpiobjdata TYPE REF TO data.
      lv_objectid = <fs_object_get>-value.

      z100085_zcl_proubc_busobjhlpr=>get_object(
        EXPORTING
          iv_objectid = lv_objectid
        IMPORTING
          et_objects  = lt_object
      ).
      READ TABLE lt_object INDEX 1 INTO ls_object.
      z100085_zcl_proubc_api_helper=>copy_data_to_ref(
              EXPORTING is_data = ls_object
              CHANGING cr_data = lv_bpiobjdata
        ).

    ELSE.
      "not sure if this ever gets called based on how handler is structured
    ENDIF.


    lo_entity = mo_response->create_entity( ).
    lo_entity->set_content_type( if_rest_media_type=>gc_appl_json ).
    lo_entity->set_string_data( /ui2/cl_json=>serialize( EXPORTING data = lv_bpiobjdata pretty_name = /ui2/cl_json=>pretty_mode-low_case ) ).
    mo_response->set_status( cl_rest_status_code=>gc_success_ok ).

  ENDMETHOD.

  METHOD if_rest_resource~put.
    DATA(lt_uriattributes) = mo_request->get_uri_attributes( ).
    DATA(lo_entity) = mo_response->create_entity( ).
    DATA lv_bpiobjdata TYPE REF TO data.
     DATA: ls_objects TYPE z100085_zif_proubc_object=>ty_create_object_req.
    DATA(lv_request_body) = mo_request->get_entity( )->get_string_data( ).
    /ui2/cl_json=>deserialize( EXPORTING json = lv_request_body CHANGING data = ls_objects ).

    DATA: ls_obj      TYPE z100085_bpiobj,
          lt_obj      TYPE z100085_ztty_bpiobj,
          lt_resp_obj TYPE z100085_ztty_bpiobj,
          ls_resp_obj type z100085_bpiobj.

    ls_obj-baseline_id = ls_objects-baseline_id.
    READ TABLE lt_uriattributes WITH KEY name = 'ID' ASSIGNING FIELD-SYMBOL(<fs_object_put>).
    IF sy-subrc = 0.
        ls_obj-object_id = <fs_object_put>-value.
    else.
        "throw error. required
    ENDIF.
    "/objects/{ID}

    append ls_obj to lt_obj.

    z100085_zcl_proubc_busobjhlpr=>update_object(
      EXPORTING
        it_objects =  lt_obj
      IMPORTING
        et_objects = lt_resp_obj
    ).

   read table lt_resp_obj index 1 into ls_resp_obj.

    z100085_zcl_proubc_api_helper=>copy_data_to_ref(
           EXPORTING is_data = ls_resp_obj
           CHANGING cr_data = lv_bpiobjdata
   ).


    lo_entity = mo_response->create_entity( ).
    "lo_entity->set_content_type( if_rest_media_type=>gc_appl_json ).
    "lo_entity->set_string_data( /ui2/cl_json=>serialize( EXPORTING data = lv_bpiobjdata pretty_name = /ui2/cl_json=>pretty_mode-low_case ) ).
    mo_response->set_status( cl_rest_status_code=>gc_success_no_content ).

  ENDMETHOD.


  METHOD if_rest_resource~post.
    DATA(lt_uriattributes) = mo_request->get_uri_attributes( ).
    DATA(lo_entity) = mo_response->create_entity( ).
    DATA lv_bpiobjdata TYPE REF TO data.
    "create the business object
    DATA: ls_objects TYPE z100085_zif_proubc_object=>ty_create_object_req.
    DATA(lv_request_body) = mo_request->get_entity( )->get_string_data( ).
    /ui2/cl_json=>deserialize( EXPORTING json = lv_request_body CHANGING data = ls_objects ).

    DATA: ls_obj      TYPE z100085_bpiobj,
          lt_obj      TYPE z100085_ztty_bpiobj,
          lt_resp_obj TYPE z100085_ztty_bpiobj.

    ls_obj-baseline_id = ls_objects-baseline_id.
    READ TABLE lt_uriattributes WITH KEY name = 'ID' ASSIGNING FIELD-SYMBOL(<fs_object_post>).
    IF sy-subrc = 0.
      ls_obj-object_id = <fs_object_post>-value.
    ELSE.
      "throw error. object id required.
    ENDIF.
    "ls_obj-proof not available
    ls_obj-schematype   = ls_objects-schema_type.
    ls_obj-schema_id = ls_objects-type.
    ls_obj-status = 'Created'.
    APPEND  ls_obj TO lt_obj.


    z100085_zcl_proubc_busobjhlpr=>create_object(
      EXPORTING
        it_objects = lt_obj
      IMPORTING
        et_objects = lt_resp_obj
    ).

    z100085_zcl_proubc_api_helper=>copy_data_to_ref(
           EXPORTING is_data = lt_resp_obj
           CHANGING cr_data = lv_bpiobjdata
   ).


    lo_entity = mo_response->create_entity( ).
    lo_entity->set_content_type( if_rest_media_type=>gc_appl_json ).
    lo_entity->set_string_data( /ui2/cl_json=>serialize( EXPORTING data = lv_bpiobjdata pretty_name = /ui2/cl_json=>pretty_mode-low_case ) ).
    mo_response->set_status( cl_rest_status_code=>gc_success_ok ).
  ENDMETHOD.

ENDCLASS.
