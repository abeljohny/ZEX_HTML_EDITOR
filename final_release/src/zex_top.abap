*&---------------------------------------------------------------------*
*&  Include           ZEX_TOP
*&---------------------------------------------------------------------*

  CONSTANTS:  c_editor(6)   TYPE c VALUE 'EDITOR',
              c_viewer(6)   TYPE c VALUE 'VIEWER',
              c_browser(7)  TYPE c VALUE 'BROWSER'.

  DATA:       g_editor        TYPE REF TO cl_gui_textedit,
              editor          TYPE REF TO cl_gui_custom_container,
              viewer          TYPE REF TO cl_gui_custom_container,
              browser         TYPE REF TO cl_gui_custom_container,
              html_viewer     TYPE REF TO cl_gui_html_viewer,
              browser_viewer  TYPE REF TO cl_gui_html_viewer,
              ok_code         LIKE sy-ucomm.
  DATA:       g_text          TYPE STANDARD TABLE OF w3html,
              text_url        TYPE c LENGTH 126,
              url             TYPE c LENGTH 256,
              g_continue      TYPE c.
