*&---------------------------------------------------------------------*
*& Include z100085_proubc_shuttleidoc_top
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK 1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: cb_test  AS CHECKBOX DEFAULT '',
              p_dir    TYPE edidc-direct DEFAULT '1',
              p_stat   TYPE edids-status DEFAULT '03',
              p_mestyp TYPE edidc-mestyp DEFAULT 'ORDERS',
              p_idoctp TYPE edidc-idoctp DEFAULT 'ORDERS05',
              p_tenant type z100085_prvdtenantid default 'e41dea7b-3510-4ffa-8ff4-53f3b158c8b4'.
  RANGES: r_poebeln FOR ekko-ebeln,
          r_idocnum FOR edidc-docnum,
          r_idoctype FOR edidc-idoctp. "default to ORDERS05
  SELECT-OPTIONS:
          s_ebeln FOR r_poebeln,
          s_idoc FOR r_idocnum,
          s_ityp FOR r_idoctype.
SELECTION-SCREEN END OF BLOCK 1.