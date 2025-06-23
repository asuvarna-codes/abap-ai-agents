# ABAP AI Agents 🤖

This repository contains an ABAP AI agent framework that integrates with Google Cloud's Vertex AI SDK to leverage Gemini for intelligent document processing. The framework is designed to enable SAP systems to interact with AI models, specifically for tasks like form data extraction.

## Project Goal

The primary goal of this project is to:
* Create an ABAP AI agent framework that utilizes the Vertex AI SDK to interact with the Gemini model.
* Test this framework by developing a "Form Processing Agent".

## Design Overview

The design of the ABAP AI agent framework involves several key components:

* **`ZTEST_FORM_PROCESSOR_AGENT` (Using Program):** This program is responsible for instantiating the Form Processor Agent, uploading files, and running user prompts.
* **`ZGOOG_CL_BASE_AGENT` (Abstract Base Agent):** This is an abstract base class that defines the fundamental structure of an agent. [cite_start]It includes abstract methods for model definition, system instructions, and tool definition.
* **`ZGOOG_CL_FORM_PROCESSOR_AGENT` (Form Processor Agent):** This class inherits from `ZGOOG_CL_BASE_AGENT` and provides specific details for the form processing agent, such as the model to be used, system instructions (agent persona), and tool definitions.

### Agent Persona (System Instructions)

The Form Processing Agent is configured with a specific persona and instructions to guide its behavior.

**Objective and Persona:**
The agent is designed to extract arbitrary data fields from supplied PDF documents. Its primary goal is to identify fields based on labels, extract corresponding values contextually, and output the data in a JSON format with lowercase-first camel case field names. A crucial aspect is to ignore any text or images identified as watermarks; if a watermark affects an extracted value, that value should also be ignored.

**Capabilities include:**
1.  **Thorough Document Review:** Understanding the PDF's structure and layout.
2.  **Watermark Handling:** Identifying and isolating watermarks and ignoring their content or affected values.
3.  **Field Identification by Label:** Locating data fields using provided labels, only extracting if labels exactly match.
4.  **Contextual Value Extraction:** Determining the relationship between a label and its value for reliable extraction.
5.  **Missing Data Handling:** Reporting unlocated labels as error fields in the output JSON's 'errors' array.
6.  **Completeness Score Calculation:** Calculating (Successfully Extracted Fields / Total Expected Fields) \* 100.

**Instructions for Task Completion:**
1.  **Step 1: Watermark Recognition and Isolation.** (First action to perform).
2.  **Step 2: Label Identification.** Locate fields by their labels and follow instructions in the prompt for value extraction.
3.  **Step 3: Value Context Determination.** Determine the relationship between the label and its value.
4.  **Step 4: Value Extraction.** Reliably extract information from the correct value field.

**Output Format:**
The output will be in JSON format with lowercase-first camel case field names. The structure will include `extractedData`, `completenessScore`, and an `errors` array for fields that failed to extract. An example output structure is provided.

## Example: Form Processing Agent

The repository includes an example of a Form Processing Agent. The prompt demonstrates how to request extraction of various fields from a PDF document, including:

* **From Page Header:** `SB No`.
* **From "PART-I - SHIPPING BILL SUMMARY" section "A STATUS" sub-section:** `6.DBK`, `7.RODTP`.
* **From "PART-I - SHIPPING BILL SUMMARY" section "C.VALU SUMMA" sub-section:** `5.COM`.
* **From "PART-I - SHIPPING BILL SUMMARY" section "D.EX.PR." sub-section:** `1.DBK CLAIM`, `5.RODTEP AMT`.
* **From "PART-I - SHIPPING BILL SUMMARY" section "F.INVOICE SUMMARY" sub-section (all records):** `1.SNO`, `2.INV NO`, `3. [cite_start]INV AMT`, `4.CURRENC`.
* **From "PART - IV - EXPORT SCHEME DETAILS" section "A. DRAWBACK & ROSL CLAIM" sub-section (all records):** `1.INV SNO`, `2.ITEM SNO`, `6.RATE`, `7.DBK AMT`.

The expected output structure for these extractions is detailed in the prompt (e.g., `sbNo`, `dbk`, `rodtp`, `com`, `dbkClaim`, `rodtepAmt`, `invoiceSummary` array, `drawbackRoslClaim` array).

## Getting Started

*(Further instructions on setting up the ABAP system, configuring Vertex AI, and running the programs would typically go here.)*

## Contributing

*(Information on how to contribute to the project would go here.)*

## License

*(License information would go here.)*
