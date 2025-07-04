import './style.css';

const fileInput = document.getElementById("fileInput") as HTMLInputElement;
const loadFileButton = document.getElementById("loadFileButton") as HTMLButtonElement;
const questionInput = document.getElementById("questionInput") as HTMLInputElement;
const submitQuestionButton = document.getElementById("submitQuestionButton") as HTMLButtonElement;
const output = document.getElementById("output") as HTMLPreElement;

let fileContent = "";

loadFileButton.addEventListener("click", async () => {
  const file = fileInput.files?.[0];
  if (!file) {
    output.textContent = "No file selected.";
    return;
  }

  try {
    const text = await file.text();
    fileContent = text;
    output.textContent = `Loaded file with ${text.length} characters.`;
  } catch (err) {
    output.textContent = "Failed to read file.";
    console.error(err);
  }
});

submitQuestionButton.addEventListener("click", async () => {
  const question = questionInput.value.trim();

  if (!question) {
    output.textContent = "Please enter a question.";
    return;
  }

  try {
    const response = await fetch("/api/test", {
      method: "GET",
    });

    const response2 = await fetch("/api/to_lambda", {
      method: "GET",
    });

    console.log(await response2.json());

    const data = await response.json();

    // Replace with your actual RAG logic
    output.textContent = `You asked: "${question}"\n(File contains ${fileContent.length} characters)\n(${data.message})`;
  } catch (err) {
    output.textContent = "Error fetching response.";
    console.error(err);
  }
});
