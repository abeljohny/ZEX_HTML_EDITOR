*&---------------------------------------------------------------------*
*&  Include           ZEX_I01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  user_command_9001  INPUT
*&---------------------------------------------------------------------*
*       Screen 9001 PAI
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT'.
      PERFORM check_editor_initial. " check if any text written in editor
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
    WHEN 'EXECUTE'.
      PERFORM exec_html.
    WHEN 'ENTER'.
      PERFORM display_webpage.
    WHEN 'REFRESH'.
      PERFORM refresh_webpage.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                 " user_command_9001  INPUT
