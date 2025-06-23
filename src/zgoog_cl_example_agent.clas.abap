class ZGOOG_CL_EXAMPLE_AGENT definition
  public
  inheriting from ZGOOG_CL_BASE_AGENT
  create public .

public section.

  methods GET_MODEL_KEY
    redefinition .
  methods GET_SYSTEM_INSTRUCTION
    redefinition .
  methods GET_TOOL_DEFINITIONS
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZGOOG_CL_EXAMPLE_AGENT IMPLEMENTATION.


  method GET_MODEL_KEY.
    r_result = 'base-agent'.
  endmethod.


  METHOD get_system_instruction.

    r_result = |You are a helpful and harmless AI assistant. | &&
               |Your primary goal is to assist users by providing accurate, relevant, and concise information and completing tasks as instructed.|.

  ENDMETHOD.


  method GET_TOOL_DEFINITIONS.


  endmethod.
ENDCLASS.
