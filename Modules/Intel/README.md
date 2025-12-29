# Intel Module

This module serves as a psychological gatekeeper, forcing "Active Recall" by requiring the user to answer a series of questions.

## Logic

1.  **Data Source**: The module reads questions from the `Questions.json` file located in this same directory.
2.  **Selection**: On execution, it randomly selects 5 questions from the JSON file.
3.  **Invocation**: It launches a blocking, modal WPF (Windows Presentation Foundation) window styled as a "Military Exam Terminal". The user cannot interact with other parts of the system until this window is satisfied.
4.  **Interaction**:
    *   The user is presented with the questions one by one.
    *   An answer must be typed into the text box.
    *   Submitting an empty answer results in a penalty (error sound, red flash) and does not advance to the next question.
    *   Submitting a non-empty answer records the response and proceeds to the next question.
5.  **Completion**: After all 5 questions are answered, the session is logged to `Intel.log` and the window closes automatically after a short delay.

## How to Add or Modify Questions

The questions are stored in a simple JSON array format in the `Questions.json` file.

To add, edit, or remove questions, simply edit the file with any text editor.

### Format Rules:

- The file must contain a single JSON array, denoted by square brackets `[` and `]`.
- Each question is a string, enclosed in double quotes `"`.
- Each string (question) must be separated by a comma `,`.
- The last question in the list should **not** have a comma after it.

### Example `Questions.json`:

```json
[
  "This is the first question?",
  "This is the second question, what are your thoughts?",
  "This is a third question."
]
```