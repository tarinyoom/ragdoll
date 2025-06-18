import './style.css';

const fileInput = document.getElementById("fileInput") as HTMLInputElement;
const questionInput = document.getElementById("questionInput") as HTMLInputElement;
const submitButton = document.getElementById("submitButton") as HTMLButtonElement;
const output = document.getElementById("output") as HTMLPreElement;

let fileContent = "";

fileInput.addEventListener("change", async () => {
  const file = fileInput.files?.[0];
  if (!file) return;

  const text = await file.text();
  fileContent = text;
  output.textContent = `Loaded file with ${text.length} characters.`;
});

submitButton.addEventListener("click", () => {
  const question = questionInput.value.trim();
  if (!fileContent || !question) {
    output.textContent = "Please upload a file and enter a question.";
    return;
  }

  // Replace with your actual RAG logic
  output.textContent = `You asked: "${question}"\n(File contains ${fileContent.length} characters)\n(Do RAG here)`;
});
