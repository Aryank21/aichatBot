# 🏏 AI Cricket Chat Assistant

An iOS chatbot that answers live cricket match questions in natural language, built with **Swift** and powered by the **Grok API (xAI)**.

This started as a standalone prototype of the AI assistant feature I later shipped in production inside [CricDaddy](https://profolio-aryan.vercel.app/) — this repo isolates just the chat/LLM integration logic.

---

## 📱 Screenshot

<p align="center">
  <img src="https://private-user-images.githubusercontent.com/105555664/653800025-acd12c99-d7f0-434c-99cc-6b2ee8fcf8cf.png" width="300" />
</p>

---

## ✨ What it does

- Answers user questions about live match state (score, overs, players) in conversational language
- Keeps a **5-message rolling conversation history**, so follow-up questions ("what about the last over?") stay coherent without re-sending full context every time
- Uses a **domain-restricted system prompt** so the assistant declines to answer anything outside cricket/match context, instead of hallucinating unrelated answers
- Injects live match data into the prompt at request time, rather than relying on the model's own (stale) knowledge

---

## 🛠️ Tech Stack

`Swift` · `UIKit` · `URLSession` · `Grok API (xAI)` · `JSON`

---

## 🧠 How the prompt architecture works

1. On each user message, the app fetches the current match state (score, current batsmen, overs)
2. That state is injected into the system prompt so the model always has fresh context, not stale training data
3. The last 5 user/assistant message pairs are kept in memory and sent with each request, giving the model short-term conversational memory without unbounded token growth
4. The system prompt explicitly constrains the assistant to match-related queries only

*(Add a short code snippet here showing the prompt-building function — a 10–15 line function that constructs the system prompt is worth more to a reviewer than any amount of prose.)*

---

## 🚧 Status

Personal prototype extracted from production learnings — actively maintained as I explore further LLM + iOS integration patterns.

---

## 📫 Contact

[Portfolio](https://profolio-aryan.vercel.app/) · [LinkedIn](https://linkedin.com/in/aryankumar99) · aryanbgp9798@gmail.com
