*&---------------------------------------------------------------------*
*&  Include           ZEX_TOP
*&---------------------------------------------------------------------*

  CONSTANTS:  c_editor(6)     TYPE c VALUE 'EDITOR',
              c_viewer(6)     TYPE c VALUE 'VIEWER'.

  DATA:       g_editor        TYPE REF TO cl_gui_textedit,
              editor          TYPE REF TO cl_gui_custom_container,
              viewer          TYPE REF TO cl_gui_custom_container,
              html_viewer     TYPE REF TO cl_gui_html_viewer,
              ok_code         LIKE sy-ucomm.
  DATA:       g_text          TYPE STANDARD TABLE OF w3html,
              url             TYPE c LENGTH 256,
              g_continue      TYPE c.
