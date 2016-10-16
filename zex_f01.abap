*----------------------------------------------------------------------*
*INCLUDE ZEX_F01 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  create_instances
*&---------------------------------------------------------------------*
FORM create_instances .
  IF editor IS INITIAL.
*   create instance for HTML Editor custom control
    CREATE OBJECT editor
      EXPORTING
        container_name              = c_editor
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6
        .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
  IF g_editor IS INITIAL.
*   create instance for HTML Editor text editor
    CREATE OBJECT g_editor
      EXPORTING
        wordwrap_mode              = cl_gui_textedit=>wordwrap_at_windowborder
        wordwrap_to_linebreak_mode = cl_gui_textedit=>true
        parent                     = editor
      EXCEPTIONS
        error_cntl_create      = 1
        error_cntl_init        = 2
        error_cntl_link        = 3
        error_dp_create        = 4
        gui_type_not_supported = 5
        OTHERS                 = 6
        .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
  PERFORM create_viewer_instances.
  IF browser IS INITIAL.
*   create instance for browser custom control
    CREATE OBJECT browser
      EXPORTING
        container_name              = c_browser
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6
        .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
  IF browser_viewer IS INITIAL.
*   create instance for browser
    CREATE OBJECT browser_viewer
      EXPORTING
        parent             =  browser
      EXCEPTIONS
        cntl_error         = 1
        cntl_install_error = 2
        dp_install_error   = 3
        dp_error           = 4
        OTHERS             = 5
        .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFORM.                    " create_instances
*&---------------------------------------------------------------------*
*&      Form  display_initial
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_initial .
  IF html_viewer IS NOT INITIAL.
    REFRESH g_text.
    APPEND '<HTML><BODY><H4>Press Execute HTML(F5) to view your HTML Output!</H4></BODY></HTML>'
    TO  g_text.
    CALL METHOD html_viewer->load_data
      IMPORTING
        assigned_url         = url
      CHANGING
        data_table           = g_text
      EXCEPTIONS
        dp_invalid_parameter = 1
        dp_error_general     = 2
        cntl_error           = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    CALL METHOD html_viewer->show_url
      EXPORTING
        url                    = url
      EXCEPTIONS
        cntl_error             = 1
        cnht_error_not_allowed = 2
        cnht_error_parameter   = 3
        dp_error_general       = 4
        OTHERS                 = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFORM.                    " display_initial
*&---------------------------------------------------------------------*
*&      Form  check_editor_initial
*&---------------------------------------------------------------------*
FORM check_editor_initial .
  IF g_editor IS NOT INITIAL.
    CALL METHOD g_editor->get_text_as_stream
      IMPORTING
        text                   = g_text
      EXCEPTIONS
        error_dp               = 1
        error_cntl_call_method = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    IF g_text IS NOT INITIAL.
      CALL FUNCTION 'C14A_POPUP_SAVE_BEFORE_ACTION'
        EXPORTING
          i_text1    = 'Unsaved Data will be lost.'
        IMPORTING
          e_continue = g_continue.
      IF g_continue = 'X'.
        LEAVE PROGRAM.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " check_editor_initial
*&---------------------------------------------------------------------*
*&      Form  EXEC_HTML
*&---------------------------------------------------------------------*
FORM exec_html .
  DATA: url TYPE c LENGTH 255.
  PERFORM free_instances.
  REFRESH g_text.
  PERFORM create_viewer_instances.
  CALL METHOD g_editor->get_text_as_stream
    IMPORTING
      text                   = g_text
    EXCEPTIONS
      error_dp               = 1
      error_cntl_call_method = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF g_text IS INITIAL.
    PERFORM display_initial.
    EXIT.
  ENDIF.
  CALL METHOD html_viewer->load_data  " generate url
    IMPORTING
      assigned_url         = url
    CHANGING
      data_table           = g_text
    EXCEPTIONS
      dp_invalid_parameter = 1
      dp_error_general     = 2
      cntl_error           = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  html_viewer->show_url( url = url ). " display HTML o/p
ENDFORM.                    " EXEC_HTML
*&---------------------------------------------------------------------*
*&      Form  free_instances
*&---------------------------------------------------------------------*
FORM free_instances .
  IF html_viewer IS NOT INITIAL.
    CALL METHOD html_viewer->free.
    FREE html_viewer.
  ENDIF.
  IF viewer IS NOT INITIAL.
    CALL METHOD viewer->free.
    FREE viewer.
  ENDIF.
ENDFORM.                    " free_instances
*&---------------------------------------------------------------------*
*&      Form  display_webpage
*&---------------------------------------------------------------------*
FORM display_webpage .
  IF text_url IS NOT INITIAL.
    CALL METHOD browser_viewer->show_url
      EXPORTING
        url                    = text_url
      EXCEPTIONS
        cntl_error             = 1
        cnht_error_not_allowed = 2
        cnht_error_parameter   = 3
        dp_error_general       = 4
        OTHERS                 = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFORM.                    " display_webpage
*&---------------------------------------------------------------------*
*&      Form  CREATE_VIEWER_INSTANCES
*&---------------------------------------------------------------------*
FORM create_viewer_instances .
  IF viewer IS INITIAL.
    CREATE OBJECT viewer
      EXPORTING
        container_name              = c_viewer
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6
        .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
  CREATE OBJECT html_viewer
    EXPORTING
      parent             =  viewer
    EXCEPTIONS
      cntl_error         = 1
      cntl_install_error = 2
      dp_install_error   = 3
      dp_error           = 4
      OTHERS             = 5
      .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    " CREATE_VIEWER_INSTANCES
*&---------------------------------------------------------------------*
*&      Form  REFRESH_WEBPAGE
*&---------------------------------------------------------------------*
FORM refresh_webpage .
  browser_viewer->do_refresh( ).
  browser_viewer->get_current_url( IMPORTING url = url ).
ENDFORM.                    " REFRESH_WEBPAGE
